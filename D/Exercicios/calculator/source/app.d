import std.stdio : writeln, writefln;
import std.random : uniform;

void randomCalculator()
{
    // Define 4 local functions for
    // 4 different mathematical operations
    auto add(int lhs, int rhs) {
        return lhs + rhs;
    }
    auto sub(int lhs, int rhs) {
        return lhs - rhs;
    }
    auto mul(int lhs, int rhs) {
        return lhs * rhs;
    }
    auto div(int lhs, int rhs) {
        return lhs / rhs;
    }

    int a = 10;
    int b = 5;

    // uniform generates a number between START
    // and END, whereas END is NOT inclusive.
    // Depending on the result we call one of
    // the math operations.
    switch (uniform(0, 4)) {
        case 0:
            writefln("Adding %s and %s", a, b);
            writeln(add(a, b));
            break;
        case 1:
            writefln("Subtracting %s from %s", b, a);
            writeln(sub(a, b));
            break;
        case 2:
            writefln("Multiplying %s and %s", a, b);
            writeln(mul(a, b));
            break;
        case 3:
            writefln("Dividing %s by %s", a, b);
            writeln(div(a, b));
            break;
        default:
            // special code which marks
            // UNREACHABLE code
            assert(0);
    }
}

void main()
{
    randomCalculator();
    // add(), sub(), mul() and div()
    // are NOT visible outside of their scope
    static assert(!__traits(compiles,
                            add(1, 2)));
}
