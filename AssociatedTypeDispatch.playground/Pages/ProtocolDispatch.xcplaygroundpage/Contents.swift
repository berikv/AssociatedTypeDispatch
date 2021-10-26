// Public
protocol P {
    associatedtype A: P
    var a: Self.A { get }
    // This example works if f() is part of P.
    //
    // When f() is not part of P, swift won't add f() to
    // the protocol's vtable, causing f() to be only
    // directly dispatched.
    //
    // f() might not make sense to be part of P. Is it
    // possible to implement the same behaviour without
    // adding f() to P?
    //
    // Comment out the next line to see an infinite
    // recursion warning on line 27.
    func f()
}

protocol Q: P {}

extension Never: P {
    var a: Never { fatalError() }
}

struct R: P {
    var a: some P { S() }
}

struct S: Q {
    var a: Never { fatalError() }
}

// Internal
extension P {
    func f() { a.f() }
}

extension Q {
    func f() { print("done") }
}

R().f()
