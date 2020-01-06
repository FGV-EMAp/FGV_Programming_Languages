module palindromic;

import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;
import std.utf;

void main(){
    uint[] candidates;
    uint maior_palindromo;
    foreach(i; 100..1000){
        for(int j; j <= i; ++j){
            candidates ~= (i*j);
        }
    }
    foreach_reverse(p; candidates.sort()){
        string n = to!string(p);
        writeln(n);
        if (n == n.retro.text){
            writeln("Maior palindromo: ", n);
            break;
        }
    }
}
