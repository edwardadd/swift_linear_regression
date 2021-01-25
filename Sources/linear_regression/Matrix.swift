#if os(Windows)
import WinSDK
#else
import Foundation
#endif

struct Matrix {
    var data: [Double]
    var rows: Int
    var columns: Int

    subscript(row: Int, column: Int) -> Double {
        data[column + row * columns]
    }

    func column(_ column: Int) -> Vector {
        var vector: [Double] = .init(repeating: 0, count: rows)
        for i in 0..<rows {
            vector[i] = data[column + i * columns]
        }

        return Vector(data: vector)
    }

    var transpose: Matrix {
        var trans = data
        for row in 0..<rows {
            for column in 0..<columns {
                trans[row + column * rows] = data[column + row * columns]
            }
        }

        return Matrix(data: trans, rows: columns, columns: rows)
    }
}

extension Matrix {
    static func * (lhs: Self, rhs: Vector) -> Vector {
        var data: [Double] = []
        for row in 0..<lhs.rows {
            var sum = 0.0
            for column in 0..<lhs.columns {
                sum += lhs.data[column + row * lhs.columns] * rhs[column]
            }
            data.append(sum)
        }

        return Vector(data: data)
    }
}

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
    static func * (lhs: Self, rhs: Double) -> Vector {
        let data = lhs.data.map({ Double($0 * rhs) })
        return Vector(data: data)
    }

    static func * (lhs: Self, rhs: Self) -> Self {
        let v = zip(lhs.data, rhs.data).map { $0.0 * $0.1}
        return Vector(data: v)
    }

    static func - (lhs: Self, rhs: Self) -> Self {
        Vector(data: zip(lhs.data, rhs.data).map { $0.0 - $0.1 })
    }
}
