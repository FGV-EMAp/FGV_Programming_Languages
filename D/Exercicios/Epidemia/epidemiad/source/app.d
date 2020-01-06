import std.stdio;
import std.datetime.stopwatch;
import std.file;
import core.exception : RangeError;

import models: SIR, SIR_Dem;


void main()
{
    double beta = 0.1;
    double gam = 1. / 21;
    int N = 150000;
    bool constant = false;
    int I0 = 2;
    double tf = 365.0;
    auto sw = StopWatch(AutoStart.no);
    auto model = new SIR(N, beta, gam);
    model.initialize(N-I0, I0, 0);
    sw.start();
    auto sim = model.run(0, tf);
    sw.stop();
    writeln(sw.peek());
    writefln("Number of steps: %s, %s,%s,%s", sim[0].length, sim[1].length,
            sim[2].length, sim[3].length);

    File outf = File("sim.csv", "w");
    outf.writeln("time,S,I,dt");
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
    double alpha = 0.1;
    auto model2 = new SIR_Dem(N, alpha, beta, gam);
    model2.initialize(N-I0, I0, 0);
    sw.start();
    auto sim2 = model2.run(0, tf);
    sw.stop();
    writeln(sw.peek());
    writefln("Number of steps for SIR_Dem: %s, %s,%s,%s", sim2[0].length, sim2[1].length,
            sim2[2].length, sim2[3].length);
}
