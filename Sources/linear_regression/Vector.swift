/*
 Vector is a list of numbers, mathematical concepts can be applied to them
 */
struct Vector {
    var data: [Double]

    subscript(index: Int) -> Double {
        data[index]
    }

    var count: Int {
        data.count
    }
}

extension Vector {
    func sum() -> Double {
        data.reduce(0, +)
    }
}

extension Vector {

    /// Scalar multiply
    static func * (lhs: Self, rhs: Double) -> Vector {
        let data = lhs.data.map({ Double($0 * rhs) })
        return Vector(data: data)
    }

    /// Member-wise multiplication
    static func * (lhs: Self, rhs: Self) -> Self {
        let v = zip(lhs.data, rhs.data).map { $0.0 * $0.1}
        return Vector(data: v)
    }

    /// Member-wise subtraction
    static func - (lhs: Self, rhs: Self) -> Self {
        Vector(data: zip(lhs.data, rhs.data).map { $0.0 - $0.1 })
    }

    /// Member-wise addition
    static func + (lhs: Self, rhs: Self) -> Self {
        Vector(data: zip(lhs.data, rhs.data).map { $0.0 + $0.1 })
    }
}
