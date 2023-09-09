#if os(Windows)
import WinSDK
#else
import Foundation
#endif

struct Matrix {
    var rows: Int
    var columns: Int
    var data: [Double]

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

        return Matrix(rows: columns, columns: rows, data: trans)
    }
}

extension Matrix {
    // Dot product
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