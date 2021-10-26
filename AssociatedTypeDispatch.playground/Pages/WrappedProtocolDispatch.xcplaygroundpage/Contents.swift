// Public interface
protocol P {
    associatedtype A: P
    var a: Self.A { get }
}

protocol Q: P {}

extension Never: P {
    var a: Never { fatalError() }
}

struct R: P {
    // This solution has no f() reqirement on P
    // and works as long as P.A is known to conform to _P
    // Switch the below lines to fix the compilation error `Type 'some P' does not confirm to protocol '_P'` on line 36
//    var a: S { S() } // this works
    var a: some P { S() } // `some P` does not conform to _P
}

struct S: Q {
    var a: Never { fatalError() }
}

// Internal, keeping f() inside
protocol _P: P where A: _P {
    func f()
}

// Another problem with this approach is that
// every type conforming to P has to also be
// conformed to _P. This prevents f() to work
// on P conforming types created by consumers
// of this API.
extension Never: _P {}
extension R: _P {}

protocol _Q: Q, _P {}
extension S: _Q {}

extension _P {
    func f() { a.f() }
}

extension _Q {
    func f() { print("done") }
}

R().f()
