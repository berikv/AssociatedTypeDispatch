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
        if p.a is Never { print("done") }
        else {
            print("Call f() on \(type(of: p.a))")
            PWrapper<T.A>(p: p.a).f()
        }
    }
}

// This example uses the `type check operator 'is'` to
// test with an explicit condition if P.A is Never.
// Alas, testing the type of S.A will retrieve its value,
// causing a fatalError().

PWrapper(p: R()).f()
// Run f() on R
// Call f() on S
// Run f() on S
// __lldb_expr_69/TypeCheckConditional.xcplaygroundpage:18: Fatal error: S.a called
