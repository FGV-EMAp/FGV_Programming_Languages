import std.stdio;
//import std.math;
import std.file;
//import std.typecons : tuple, Tuple;
import core.exception : RangeError;
//import mir.random;
//import mir.random.variable : uniformVar, exponentialVar;
//import mir.ndslice;
//import mir.ndslice.fuse;
import models: SIR;


void main()
{
    double beta = 0.1;
    double gam = 1. / 21;
    int N = 15000;
    bool constant = false;
    int I0 = 2;
    double tf = 365.0;
    auto model = new SIR(N, beta, gam);
    model.initialize(N-I0, I0, 0);
    auto sim = model.run(0, tf);
    writefln("Number of steps: %s, %s,%s,%s", sim[0].length, sim[1].length,
            sim[2].length, sim[3].length);

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
