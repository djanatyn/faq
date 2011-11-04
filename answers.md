# Perl 6 FAQ

Source can be found [on github](https://github.com/perl6/faq).

<span id="language" />
## Language Features

<span id="so" />
### What is `so`?

`so` is loose precedence operator that coerces to `Bool`.

It has the same semantics as the `?` prefix operator, just like
`and` is the low-precedence version of `&&`.

Example usage:

    say so 1|2 == 2;    # Bool::True

In this example, the result of the comparison (which is a `Junction`), is
converted to Bool before being printed.

<span id="eigenstate" />
### How can I extract the eigenstates from a `Junction`?

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


<span id="immutable" />
### If Str is immutable, how does `s///` work? if Int is immutable, how does `$i++` work?

In Perl 6, many basic types are immutable, but the variables holding them are
not. The `s///` operator works on a variable, into which it puts a newly
creates string object. Likewise `$i++` works on the `$i` variable, not
just on the value in it.

<span id="ref" />
## What's up with array references and automatic derferencing? Do I still need
the `@` sigil?

In Perl 6, nearly everything is a reference, so talking about taking
references doesn't make much sense. Unlike Perl 5, scalar variables
can also contain arrays directly:

    my @a = 1, 2, 3;
    say @a;                 # 1, 2, 3
    say @a.WHAT;            # Array()

    my $scalar = @a;
    say $scalar;            # 1, 2, 3
    say $scalar.WHAT;       # Array()

The big difference is that arrays inside a scalar variable do not flatten in
list context:

    my @a = 1, 2, 3;
    my $s = @a;

    for @a { ... }          # loop body executed 3 times
    for $s { ... }          # loop body executed only once

    my @flat = @a, @a;
    say @flat.elems;        # 6

    my @nested = $s, $s;
    say @nested.elems;      # 2

You can force flattening with `@( ... )` or by calling the `.list` method
on an expression, and item context (not flattening) with `$( ... )`
or by calling the `.item` method on an expression.

`[...]` array literals do not flatten into lists.


<span id="coroutine" />
### Does Perl 6 have coroutines? What about `yield`?

Perl 6 has no `yield` statement like python does, but it does offer similar
functionality through lazy lists. There are two popular ways to write
routines that return lazy lists:

    # first method, gather/take
    my @values := gather while have_data() {
        # do some computations
        take some_data();
        # do more computations
    }

    # second method, use .map or similar method
    # on a lazy list
    my @squares := (1..*).map(-> $x { $x * $x });


<span id="meta" />
## Meta Questions and Advocacy

<span id="ready" />
### When will Perl 6 be ready? Is it ready now?

Readiness of programming languages and their compilers is not a binary
decision. As they (both the language and the implementations) evolve, they
grow steadily more usable. Depending on your demands on a programming
language, Perl 6 and its compilers might or might not be ready for you.

Please see the [feature comparison
matrix](http://perl6.org/compilers/features) for an overview of implemented
features.


### Why should I learn Perl 6? What's so great about it?

Perl 6 unifies many great ideas that aren't usually found in other programming
languages. While several other languages offer some of these features, none of
them offer all.

Unlike most languages, it offers

* cleaned up regular expressions
* PEG like grammars for parsing
* lazy lists
* a powerful meta object system
* junctions of values
* easy access to higher-order functional features like partial application and currying
* separate mechanism for subtyping (inheritance) and code reuse (role application)
* optional type annotations
* power run-time multi dispatch for both subroutines and methods based on
  arity, types and additional code constraints
* lexical imports

It also offers

* closures
* anonymous types
* roles and traits
* named arguments
* nested signatures
* object unpacking in signatures
* intuitive, nice syntax (unlike Lisp)
* easy to understand, explicit scoping rules (unlike Python)
* a strong meta object system that does not rely on eval (unlike Ruby)
* expressive routine signatures (unlike Perl 5)
* state variables
* named regexes for easy reuse
