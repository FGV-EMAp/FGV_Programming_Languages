module palindromic;

import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;

void main(string[] args){
    uint[] candidates;
    uint maior_palindromo;
    candidates ~= 1;
    foreach(i; 100..1000){
        for(int j; j <= i; ++j){
            candidates ~= (i*j);
        }
    }
    foreach_reverse(p; candidates.sort()){
        string n = to!string(p);
        if (n == n.retro.text){
            writeln("Maior palíndromo: ", n);
            break;
        }
    }
}
