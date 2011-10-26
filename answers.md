# Perl 6 FAQ

Source to be found [on github](https://github.com/perl6/faq).

## What is `so`?

`so` is loose precedence operator that coerces to `Bool`.

It has the same semantics as the `?` prefix operator, just like
`and` is the low-precedence version of `&&`.

Example usage:

    say so 1|2 == 2;    # Bool::True

In this example, the result of the comparison (which is a `Junction`), is
converted to Bool before being printed.

## How can I extract the eigenstates from a `Junction`?

If you want to extract the eigenstates from a junction, you are doing
something wrong. Junctions are meant as matchers, not for doing algebra
with them.

If you want to do it anyway, you can abuse autothreading for that:

    sub eigenstates(Mu $j) {
        my @states;
        -> Any $s { @states.push: $s }.($j);
        @states;
    }

    say eigenstates(1|2|3).join(', ');
    # prints 1, 2, 3 or a permutation thereof
