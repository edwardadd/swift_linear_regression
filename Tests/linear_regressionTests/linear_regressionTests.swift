import XCTest
import class Foundation.Bundle
@testable import linear_regression

final class linear_regressionTests: XCTestCase {

    func testMatrixSetup() {
        let M = Matrix(data: [1, 0, 0, 1], rows: 2, columns: 2)
        XCTAssert(M[0,0] == 1)
        XCTAssert(M[0,1] == 0)
        XCTAssert(M[1,0] == 0)
        XCTAssert(M[1,1] == 1)
    }

    func testMatrixColumnAccess() {
        let M = Matrix(data: [1, 2, 3, 4], rows: 2, columns: 2)
        XCTAssert(M.column(0)[0] == 1)
        XCTAssert(M.column(0)[1] == 3)
        XCTAssert(M.column(1)[0] == 2)
        XCTAssert(M.column(1)[1] == 4)
    }

    func testMatrixVectorMultiplication() {
        let M = Matrix(data: [1, 2, 3, 4], rows: 2, columns: 2)
        let v = Vector(data: [2, 3])

        let P = M * v
        XCTAssert(P[0] == 8)
        XCTAssert(P[1] == 18)
    }

    func testVectorSubtraction() {
        let v = Vector(data: [2, 3])
        let v2 = Vector(data: [1, 1])
        let v3  = v - v2
        XCTAssert(v3[0] == 1)
        XCTAssert(v3[1] == 2)
    }

    func testLargerMatrixColumns() {
        let M = Matrix(data: [1, 2, 3, 4, 5, 6], rows: 2, columns: 3)
        XCTAssert(M.column(0)[0] == 1)
        XCTAssert(M.column(0)[1] == 4)
        XCTAssert(M.column(1)[0] == 2)
        XCTAssert(M.column(1)[1] == 5)
        XCTAssert(M.column(2)[0] == 3)
        XCTAssert(M.column(2)[1] == 6)
    }

    func testMatrixTranspose() {
        var M = Matrix(data: [1, 2, 3, 4, 5, 6], rows: 2, columns: 3)
        M = M.transpose
        XCTAssert(M.data == [1, 4, 2, 5, 3, 6])
    }

    static var allTests = [
        ("testMatrixSetup", testMatrixSetup),
        ("testMatrixColumnAccess", testMatrixColumnAccess),
        ("testMatrixVectorMultiplication", testMatrixVectorMultiplication),
        ("testVectorSubtraction", testVectorSubtraction),
        ("testLargerMatrixColumns", testLargerMatrixColumns),
        ("testMatrixTranspose", testMatrixTranspose),
    ]
}
