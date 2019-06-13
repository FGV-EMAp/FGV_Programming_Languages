# Exercicios para o aprendizado de **D**

1. *Olá Mundo:* Compile e execute o programa alomundo digitando no diretorio: `dub run`. Experimente escrever um script alo mundo e executa-lo com `rdmd`
1. *Imports e modulos:* Imports funcionam de forma semelhante ao Python. No exercicio anterior, importamos stdio a partir da biblioteca padrao do **D** ou `std`:
    ```D
    import std.stdio;
    ```
    Mas tambem podemos importar partes de um modulo:
    ```D
    import std.stdio: writeln, writefln;
    ```
1. *Tipos basicos:*

    |type|size|
    |--- |--- |
    |bool|8-bit|
    |byte, ubyte, char|8-bit|
    |short, ushort, wchar|16-bit|
    |int, uint, dchar|32-bit|
    |long, ulong|64-bit|
    |float|32-bit|
    |double|64-bit|
    |real| \>= 64-bit (geralmente 64-bit)
    
    ```D
    import std.stdio : writeln;

    void main()
    {
        // numeros grandes podem ser separados 
        // com "_" para
        // facilitar a leitura.
        int b = 7_000_000;
        short c = cast(short) b; // cast needed
        uint d = b; // fine
        int g;
        assert(g == 0);
    
        auto f = 3.1415f; // f denotes a float
    
        // typeid(VAR) returna o tipo de uma 
        // expressao.
        writeln("type of f is ", typeid(f));
        double pi = f; // fine
        // Para tipos floating-point
        // o down-casting e permitido
        float demoted = pi;
    
        // access to type properties
        assert(int.init == 0);
        assert(int.sizeof == 4);
        assert(bool.max == 1);
        writeln(int.min, " ", int.max);
        writeln(int.stringof); // int
    }
    ```
    Resolva:
     - Execute o codigo acima com `rdmd`;
     - modifique o codigo para imprimir o valor de `c`;
     - Demonstre em codigo, o porque do valor de `c`;
