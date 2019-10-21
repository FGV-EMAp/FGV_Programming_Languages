module multinomial;

import std.stdio;
import std.algorithm;
import std.range;
import mir.random;
import std.datetime;//.timezone : LocalTime;
import mir.random.variable : uniformVar, exponentialVar, binomialVar;


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
size_t[] multinomialVar(const uint N,  double[] probs)
{
    double norm = 0.0;
    double sum_p = 0.0;
    alias rng = rne; /// default randon engine, uniquely seeded

    uint sum_n = 0;
    size_t[] n;

    /* probs may contain non-negative weights that do not sum to 1.0.
   * Even a probability distribution will not exactly sum to 1.0
   * due to rounding errors.
   */

    foreach (k, p; probs)
    {
        n ~= 0; /// intializing array n
        norm += p;
    }

    foreach (k, p; probs)
    {
        if (p > 0.0)
        {
            auto rv = binomialVar( N - sum_n, p / (norm - sum_p));
            n[k] = rv(rng);

        }
        else
        {
            n[k] = 0;
        }

        sum_p += p;
        sum_n += n[k];
    }
    return n;
}

unittest{
    int n = 10000;
    foreach(i; 1..10){
        auto sample = multinomialVar(n, [1.0/6, 2.0/6, 3.0/6]);
        writeln(sample);
    }
    auto sample = multinomialVar( n, [ 32, 10, 100]);
    assert(sum(sample) == n);
}
