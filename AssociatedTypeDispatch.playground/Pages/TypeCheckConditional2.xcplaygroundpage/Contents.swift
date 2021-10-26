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
struct PWrapper<T: P> {
    let p: T
    func f() {
        print("Run f() on \(type(of: p))")
        if p is S { print("done") }
        else {
            print("Call f() on \(type(of: p.a))")
            PWrapper<T.A>(p: p.a).f()
        }
    }
}

// This implementation is getting really close.
// No infinite recursion. P does not require f().
// The downside is that any type that has `P.A == Never`
// will crash f() unless f() has a condition to prevent that.

PWrapper(p: R()).f()
