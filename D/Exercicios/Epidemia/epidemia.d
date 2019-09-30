#!/usr/bin/env rdmd
/+dub.sdl:
dependency "mir" version="~>3.1.0"
dependency "mir-random" version="~>2.2.4"
dependency "mir-algorithm" version="~>3.2.1"
dependency "matplotlib-d" version="~>0.1.5"
+/
import std.stdio;
import std.math;
import std.file;
import std.typecons : tuple, Tuple;
import core.exception : RangeError;
import mir.random;
import mir.random.variable : uniformVar, exponentialVar;
import mir.ndslice;
import mir.ndslice.fuse;
import plt = matplotlibd.pyplot;

auto run_sir(int N, double tf, double beta, double gam, int I0)
{
    writefln("N: %s\nbeta: %s", N, beta);

    auto rng = Random(1628376);
    auto urv = uniformVar!double(0.0, 1.0);

    double[] t = [0.0];
    int[] S = [N - I0];
    int[] I = [I0];
    double[] dts = [0];
    double R, U, pinf;
    while ((t[$ - 1] < tf) & (I[$ - 1] > 0))
    {
        U = urv(rng);
        // writeln(U);
        R = beta * S[$ - 1] * I[$ - 1] / N + gam * I[$ - 1];
        // if (S[$-1]==0){writefln("%s, %s, %s, %s, %s",beta,S[$-1],I[$-1], N, gam);}
        pinf = ((beta / N) * S[$ - 1] * I[$ - 1]) / R; // Probability of next event being an infection
        auto erv = exponentialVar!double(1.0 / R);
        double dt = erv(rng);
        if (U <= pinf)
        { // Next event is an infection
            S ~= [S[$ - 1] - 1];
            I ~= [I[$ - 1] + 1];
            t ~= [t[$ - 1] + dt];
            dts ~= [dt];
        }
        else
        { // next event is a recovery
            S ~= [S[$ - 1]];
            I ~= [I[$ - 1] - 1];
            // writeln("removal");
            t ~= [t[$ - 1] + dt]; // -np.log(rand())/R);
            dts ~= [dt];
        }
    }
    writefln("last R: %s", R);
    auto res = tuple(t, S, I, dts);

    return res;
}

void main()
{
    double beta = 0.1;
    double gam = 1. / 21;
    int N = 150000;
    bool constant = false;
    int I0 = 2;
    double tf = 365.0;
    auto sim = run_sir(N, tf, beta, gam, I0);
    writefln("Number of steps: %s, %s,%s,%s", sim[0].length, sim[1].length,
            sim[2].length, sim[3].length);
    plt.plot(sim[0][0 .. $ - 1], sim[2][0 .. $ - 1]);
    // plt.plot(sim[0][0..$-1], sim[1][0..$-1]);

    plt.show();
    File outf = File("sim.csv", "w");
    outf.writeln("time, S, I, dt");
    foreach (i, double t; sim[0])
    {
        try
        {
            outf.writefln("%s,%s,%s,%s", t, sim[1][i], sim[2][i], sim[3][i]);
        }
        catch (RangeError e)
        {
            writefln("t: %s\t S: %s\t I: %s\t dt:%s", t, sim[1][i], sim[2][i], sim[3][i]);
        }
    }
    outf.close();
}
