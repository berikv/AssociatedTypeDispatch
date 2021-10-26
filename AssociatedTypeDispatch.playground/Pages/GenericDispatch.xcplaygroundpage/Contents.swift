// Public
protocol P {
    associatedtype A: P
    var a: Self.A { get }
}

protocol Q: P {}

extension Never: P {
    var a: Never { fatalError() }
}

struct R: P {
    var a: S { S() }
}

struct S: Q {
    var a: Never { fatalError() }
}

// Internal
struct PWrapper<T: P> {
    let p: T

    func f() where T.A == Never { print("done") }
    func f() { PWrapper<T.A>(p: p.a).f() }
}

// Generic dispatch has my preference: It gives more
// optimisation hints to the compiler, and can be
// more clear in intention (less noisy).
//
// However I can't get the compiler to dispatch based on
// an associated type. (I'm not sure if I tested every
// possible implementation).
//
// In this example, f() on S() will run as expected;
// while f() on R() will go into infinite recursion.

// S.A is found to be `Never`
// prints "done"
PWrapper(p: S()).f()

// R.A.A is not used as a dispatch criteria
// infinite recursion triggered from here
PWrapper(p: R()).f()
