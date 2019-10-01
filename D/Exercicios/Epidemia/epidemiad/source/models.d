/**
Continuous time  Markov model implementing an SIR epidemic Model
Author: Flávio Codeço Coelho<fccoelho@gmail.com>
License: MIT
*/
/** Copyright: Flávio Codeço Coelho */
module models;

import std.stdio;
import std.math;
import std.file;
import std.typecons : tuple, Tuple;
import core.exception : RangeError;
import mir.random;
import mir.random.variable : uniformVar, exponentialVar, binomialVar;
import mir.ndslice;
import mir.ndslice.fuse;
import pyd.pyd;

///SIR model class.
class SIR
{
    uint[3] inits;
    uint[] S, I, R;
    double[] ts;
    uint N;
    double beta;
    double gam;
    this(uint N, double beta, double gam)
    {
        this.N = N;
        this.beta = beta;
        this.gam = gam;
    }
    /**
    Set the initial values for state
    Params:
        S = Initial number of susceptibles
        I = Initial number of infectious
        R = Initial number of Removed
    */
    void initialize(uint S, uint I, uint R)
    {
        this.S ~= S;
        this.I ~= I;
        this.R ~= R;
    }
    /**
    Starts simulation.

    Params:
        t0 = initial time
        tf = final time
    */
    Tuple!(double[], uint[], uint[], double[]) run(double t0, double tf, uint seed = 7687738)
    {
        this.ts ~= t0;
        auto rng = Random(seed);
        auto urv = uniformVar!double(0.0, 1.0);
        double[] dts = [0];
        double R, U, pinf;
        while ((this.ts[$ - 1] < tf) & (this.I[$ - 1] > 0))
        {
            U = urv(rng);
            // writeln(U);
            R = this.beta * this.S[$ - 1] * this.I[$ - 1] / this.N + this.gam * this.I[$ - 1];
            // if (S[$-1]==0){writefln("%s, %s, %s, %s, %s",beta,S[$-1],I[$-1], N, gam);}
            pinf = ((this.beta / this.N) * this.S[$ - 1] * this.I[$ - 1]) / R; // Probability of next event being an infection
            auto erv = exponentialVar!double(1.0 / R);
            double dt = erv(rng);
            if (U <= pinf)
            { // Next event is an infection
                this.S ~= [this.S[$ - 1] - 1];
                this.I ~= [this.I[$ - 1] + 1];
                this.ts ~= [this.ts[$ - 1] + dt];
                dts ~= [dt];
            }
            else
            { // next event is a recovery
                this.S ~= [this.S[$ - 1]];
                this.I ~= [this.I[$ - 1] - 1];
                // writeln("removal");
                this.ts ~= [this.ts[$ - 1] + dt]; // -np.log(rand())/R);
                dts ~= [dt];
            }
        }

        writefln("last R: %s", R);
        auto res = tuple(this.ts, this.S, this.I, dts);

        return res;
    }
}

/**
SIR model with demography (births and deaths.
*/
class SIR_Dem : SIR
{
    private
    {
        double alpha;
    }
    this(uint N, double alpha, double beta, double gamma)
    {
        super(N, beta, gamma);
        this.alpha = alpha;
    }

    override Tuple!(double[], uint[], uint[], double[]) run(double t0, double tf, uint seed = 76838)
    {
        this.ts ~= t0;
        auto rng = Random(seed);
        auto urv = uniformVar!double(0.0, 1.0);
        double[] dts = [0];
        double R, U, pinf, prec, pbirth, pds, pdi;
        while ((this.ts[$ - 1] < tf) & (this.I[$ - 1] > 0))
        {
            U = urv(rng);
            R = this.alpha * this.N + this.beta * this.S[$ - 1] * this.I[$ - 1]
                / this.N + this.gam * this.I[$ - 1] + this.alpha * this.S[$ - 1]
                + this.alpha * this.I[$ - 1];
            pbirth = this.alpha * this.N / R; /// Probability of the next event being a birth (S -> S+1)
            pinf = ((this.beta / this.N) * this.S[$ - 1] * this.I[$ - 1]) / R; /// Probability of next event being an infection
            prec = this.gam * this.I[$ - 1] / R; /// Probability of the next event being a recovery (I -> I-1)
            pds = this.alpha * this.S[$ - 1] / R; /// Probability of the next event being a death of an S (S -> S-1)
            pdi = this.alpha * this.I[$ - 1] / R; /// Probability of the next event being a death of an I (I -> I-1)
            ev = multinomial(1, [pbirth, pinf, prec, pds, pdi]).nonzero();
            auto erv = exponentialVar!double(1.0 / R);
            double dt = erv(rng);
            if (ev == 0)
            { ///event is a birth
                this.S ~= this.S[$ - 1] + 1;
                this.I ~= this.I[$ - 1];
            }
            else if (ev == 1)
            { ///  event is an infection
                this.S ~= this.S[$ - 1] - 1;
                this.I ~= this.I[$ - 1] + 1;
            }
            else if (ev == 2)
            { /// event is a recovery
                this.S ~= this.S[$ - 1];
                this.I ~= this.I[$ - 1] - 1;
            }
            else if (ev == 3)
            { /// event is a susceptible death
                this.S ~= this.S[$ - 1] - 1;
                this.I ~= this.I[$ - 1];
            }
            else if (ev == 4)
            { /// next event is a infectious death
                this.S ~= this.S[$ - 1];
                this.I ~= this.I[$ - 1] - 1;
            }
            this.ts ~= this.ts[$ - 1] + dt;
            dts ~= dt;
        }
        auto res = tuple(this.ts, this.S, this.I, dts);
        return res;
    }
}

/** The multinomial distribution has the form
                                      N!           n_1  n_2      n_K
   prob(n_1, n_2, ... n_K) = -------------------- p_1  p_2  ... p_K
                             (n_1! n_2! ... n_K!)
   where n_1, n_2, ... n_K are nonnegative integers, sum_{k=1,K} n_k = N,
   and p = (p_1, p_2, ..., p_K) is a probability distribution.
   Random variates are generated using the conditional binomial method.
   This scales well with N and does not require a setup step.
   Ref:
   C.S. David, The computer generation of multinomial random variates,
   Comp. Stat. Data Anal. 16 (1993) 205-217
*/
void multinomialVar(const uint N, const double[] p, ulong[] n)
{
    uint k;
    auto K = p.length;
    double norm = 0.0;
    double sum_p = 0.0;
    auto rng = Random(12784);
    uint sum_n = 0;

    /* p[k] may contain non-negative weights that do not sum to 1.0.
   * Even a probability distribution will not exactly sum to 1.0
   * due to rounding errors.
   */

    for (k = 0; k < K; k++)
    {
        norm += p[k];
    }

    for (k = 0; k < K; k++)
    {
        if (p[k] > 0.0)
        {
            auto rv = binomialVar(N - sum_n, p[k] / (norm - sum_p));
            n[k] = rv(rng);

        }
        else
        {
            n[k] = 0;
        }

        sum_p += p[k];
        sum_n += n[k];
    }

}

/**
* Python wrapper
*/
extern (C) void PydMain()
{
    module_init();
    wrap_class!(SIR, Def!(SIR.initialize), Def!(SIR.run), Init!(uint, double, double))();
    wrap_class!(SIR_Dem, Init!(uint, double, double, double))();

}
