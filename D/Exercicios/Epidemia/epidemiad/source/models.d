module models;

import std.stdio;
import std.math;
import std.file;
import std.typecons : tuple, Tuple;
import core.exception : RangeError;
import mir.random;
import mir.random.variable: uniformVar, exponentialVar;
import mir.ndslice;
import mir.ndslice.fuse;
import pyd.pyd;

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

    void initialize(uint S, uint I, uint R)
    {
        this.S ~= S;
        this.I ~= I;
        this.R ~= R;
    }

    auto run(double t0, double tf, uint seed=7687738)
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
* Python wrapper
*/
extern (C) void PydMain()
{
    module_init();

    wrap_class!(SIR, Property!(SIR.initialize), Property!(SIR.run),
            Init!(uint, double, double))();

}
