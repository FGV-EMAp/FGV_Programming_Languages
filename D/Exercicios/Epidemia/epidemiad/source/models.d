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
import std.range : enumerate;
import std.algorithm.searching;
import std.typecons : tuple, Tuple;
import core.exception : RangeError;
import mir.random;
import mir.random.variable : uniformVar, exponentialVar;
import mir.interpolate.linear;
import multinomial: multinomialVar;
import mir.array.allocation;
import mir.ndslice;
import mir.ndslice.fuse;
import pyd.pyd;

///SIR model class.
class SIR
{
    uint[3] inits;
    uint S0, I0, R0;
    uint[] S, I, R;
    double[] ts;
    uint N;
    double beta;
    double gam;
    @nogc this(const uint N, const double beta, const double gam)
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
        S0 = S;
        I0 = I;
        R0 = R;
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
    Tuple!(double[], uint[], uint[], double[]) run(const double t0, const double tf, uint seed = 7687738)
    {
        if (this.ts.length > 1){
            this.ts = [ t0];
            this.S = [ S0];
            this.I = [ I0];
            this.R = [ R0];
        }
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
SIR model with demography (births and deaths).
*/
class SIR_Dem : SIR
{
    private
    {
        double alpha;
    }
    @nogc this(const uint N, const double alpha, const double beta, const double gamma)
    {
        super(N, beta, gamma);
        this.alpha = alpha;
    }

    override Tuple!(double[], uint[], uint[], double[]) run(const double t0, const double tf, uint seed = 76838)
    {
        if (this.ts.length > 1){
            this.ts = [ t0];
            this.S = [ S0];
            this.I = [ I0];
            this.R = [ R0];
        }
        ts ~= t0;
        auto rng = Random(seed);
        auto urv = uniformVar!double(0.0, 1.0);
        double[] dts = [0];
        double R, U, pinf, prec, pbirth, pds, pdi;
        while ((ts[$ - 1] < tf) & (I[$ - 1] > 0))
        {
            U = urv(rng);
            R = alpha * N + beta * S[$ - 1] * I[$ - 1]
                / N + gam * I[$ - 1] + alpha * S[$ - 1]
                + alpha * I[$ - 1];
            pbirth = alpha * N / R; /// Probability of the next event being a birth (S -> S+1)
            pinf = ((beta / N) * S[$ - 1] * I[$ - 1]) / R; /// Probability of next event being an infection
            prec = gam * I[$ - 1] / R; /// Probability of the next event being a recovery (I -> I-1)
            pds = alpha * S[$ - 1] / R; /// Probability of the next event being a death of an S (S -> S-1)
            pdi = alpha * I[$ - 1] / R; /// Probability of the next event being a death of an I (I -> I-1)
            auto ev = multinomialVar(1, [pbirth, pinf, prec, pds, pdi]).enumerate.maxElement!"a.value"[0];
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
/// Checking N is being initialized on the superclass
unittest{
    auto model = new SIR_Dem( 150000, 0.1, 0.2, 1/21.);
    assert (model.N==150000);
}
/// Checking model can be run twice
unittest{
    auto model = new SIR_Dem( 1500, 0.1, 0.2, 1/21.);
    model.initialize( 1498, 2, 0);
    model.run( 0.0, 365.0);
    model.run( 0.0, 365.0);

}


/**
Influenza model model with environmental forcing
*/
class Influenza
{
    double m,phi,pi,e,w,r,rc;
    Linear!(double, 1LU, immutable(double)*)[string] ff; //associative arrays to store forcing functions
    uint S0, I0,V0,C0,R0, N;
    //auto tmat = slice!int(15,5);
    int[][] tmat = [[1,0,0,0,0],
            [-1,0,1,0,0],
            [-1,0,1,0,0],
            [-1,0,0,1,0],
            [-1,1,0,0,0],
            [-1,0,0,0,0],
            [1,-1,0,0,0],
            [0,-1,1,0,0],
            [0,-1,0,0,0],
            [0,0,-1,0,1],
            [0,0,-1,0,0],
            [0,0,0,-1,1],
            [0,0,0,-1,0],
            [1,0,0,0,-1],
            [0,0,0,0,-1]];

    this(uint N, double[] pars)
    {
        this.N = N;
        this.m = pars[0];
        this.phi = pars[1];
        this.pi = pars[2];
        this.e = pars[3];
        this.w = pars[4];
        this.r = pars[5];
        this.rc = pars[6];
    }

    /**
    Add forcing functions beta, beta_v, nu, and gam
    params:
    name: name of the function from the list above.
    t: the t values
    y: the y values
    */
    void add_forcing(string name, immutable double[] t, immutable double[] y){
        this.ff[name] = linear!double(t.sliced,y.sliced);
    }

    void initialize(uint S0, uint I0, uint V0, uint C0, uint R0)
    {
        this.S0 = S0;
        this.I0 = I0;
        this.V0 = V0;
        this.C0 = C0;
        this.R0 = R0;
    }
    Tuple!(double[], int[][]) run(double t0, double tf)
    {
        int[][] state;
        auto rng = Random(2345);
        state ~= [S0, V0, I0, C0, R0];
        double[] ts = [0.0];
        double t = 0;
        while (t < tf) //& (state[$-1][2] + state[$-1][1]+ state[$-1][3]>0))
        {
            int S = state[$-1][0];
            int V = state[$-1][1];
            int I = state[$-1][2];
            int C = state[$-1][3];
            int R = state[$-1][4];

            double T = m*N + (1-pi)*ff["beta"](t)/N*S*I + phi*S + pi*ff["beta"](t)/N*S*I + e*ff["nu"](t)*S + m*S + w*V + ff["beta_v"](t)*V*I/N + m*V + r*I + m*I + rc*C + m*C + ff["gam"](t)*R + m*R;
            auto erv = exponentialVar!double(1.0 / T);
            auto urv = uniformVar!double(0.0, 1.0);
            double dt = erv(rne);//-log(urv(rng))/T;
            auto ev = multinomialVar(1, [m*N/T,
                                 ((1-pi)*ff["beta"](t)/N*S*I)/T,
                                 (phi*S)/T,
                                 (pi*ff["beta"](t)/N*S*I)/T,
                                 (e*ff["nu"](t)*S)/T,
                                 (m*S)/T,
                                 (w*V)/T,
                                 (ff["beta_v"](t)*V*I/N)/T,
                                 (m*V)/T,
                                 (r*I)/T,
                                 (m*I)/T,
                                 (rc*C)/T,
                                 (m*C)/T,
                                 (ff["gam"](t)*R)/T,
                                 (m*R)/T]).enumerate.maxElement!"a.value"[0];
            auto new_state = state[$-1].dup;
            foreach(i, x; tmat[ev]){
                new_state[i] += x;
            }
            //writefln("t: %s",t);
            //writefln("dt: %s",dt);
            //writeln(ev);
            state ~= new_state;
            t += dt;
            ts ~= t;

        }
        return tuple(ts, state);
    }
}


/**
* Python wrapper
*/
extern (C) void PydMain()
{
    module_init();
    wrap_class!(SIR, Def!(SIR.initialize), Def!(SIR.run), Init!(const uint, const double, const double))();
    wrap_class!(SIR_Dem, Init!(const uint, const double, const double, const double), Def!(SIR_Dem.run), Def!(SIR_Dem.initialize))();
    wrap_class!(Influenza, Init!(uint, double[]),
    Def!(Influenza.initialize),
    Def!(Influenza.add_forcing),
    Def!(Influenza.run)
    )();
}
