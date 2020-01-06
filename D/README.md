# Linguagem D

[dlang.org](https://dlang.org) 

**D** é uma linguagem de programação de uso geral com tipagem estática, acesso em nível de sistema e sintaxe semelhante a **C**. Com a linguagem de programação **D**, escreva rapidamente, leia rapidamente e executa rápido.


## Configurando o ambiente
Para começar a programar em **D** e preciso apenas ter um [compilador instalado](https://dlang.org/download.html).
existem tres compiladores disponiveis:

 - DMD: Mais atualizado, rapido. Mas compila apenas para as plataformas i386 e adm64
 - GDC: Da familia [GCC](https://gcc.gnu.org/). Suporta todas as arquiteturas que o GCC suporta 
 - LDC: Baseado no compilador [LLVM](http://llvm.org/). Suporta varias arquiteturas e tambem [android](https://wiki.dlang.org/Build_D_for_Android).

## IDEs

Varias IDEs podem ser utilizadas para programar em D:

 - Pycharm (com plugin para D)
 - [Dexed](https://github.com/Basile-z/dexed) 
 - [Online D editor](https://run.dlang.io) 

## Introdução à linguagem

Abaixo segue uma adaptação livre de alguns exemplos da documentação do D.

 - Alô Mundo!
```D
import std.stdio;
import std.algorithm;
import std.range;

void main()
{
    // Let's get going!
    writeln("Alô Mundo!");

    // Ordenando 3 arrays inplace sem alocar
    // memoria extra
    int[] arr1 = [4, 9, 7];
    int[] arr2 = [5, 2, 1, 10];
    int[] arr3 = [6, 8, 3];
    sort(chain(arr1, arr2, arr3));
    writefln("%s\n%s\n%s\n", arr1, arr2, arr3);
}
```
