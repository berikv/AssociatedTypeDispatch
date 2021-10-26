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
    var a: Never { fatalError("S.a called") }
}

// Internal
protocol PW {
    associatedtype _P: P
    var p: _P { get }
    func f()
}

struct PWrapper<T: P>: PW {
    let p: T
    init(p: T) {
        self.p = p
    }
    func f() {
        if p.a is Never { print("done") }
        else { PWrapper<T.A>(p: p.a).f() }
    }
}

// This example uses the `type check operator 'is'` to
// test with an explicit condition if P.A is Never.
// Alas, the test fails even if P.A is Never.

PWrapper(p: R()).f()
