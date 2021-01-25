#if os(Windows)
import WinSDK
#else 
import Foundation
#endif

func prediction(_ theta: Vector, _ X: Matrix) -> Vector {
    X * theta
}

func cost(theta: Vector, X: Matrix, Y: Vector, j: Int) -> Double {
    let error = (prediction(theta, X) - Y) * X.column(j)
    return error.data.reduce(0, +) / Double(Y.count)
}

func gradientDescent(_ theta: Vector,
                      _ data: Matrix,
                    _ result: Vector,
                    _ learningRate: Double) -> (Vector, Int) {
    var prevError: Vector = Vector(data: [-1, -1])
    var iteration = 0
    var theta = theta

    repeat {
        var costValue: Vector = Vector(data: [-1, -1])
        for j in 0..<theta.count {
            costValue.data[j] = cost(theta: theta, X: data, Y: result, j: j)
        }
        print("Iteration: \(iteration) - theta \(theta) error \(costValue)")

        if costValue[0].isNaN || theta[0].isNaN ||
            costValue[1].isNaN || theta[1].isNaN {
            break
        }

        var done = true
        for j in 0..<theta.count {
            if !costValue[j].isEqual(to: prevError[j]) {
                done = false
                break
            }
        }

        if done {
            break
        }

        prevError = costValue
        theta = theta - (costValue * learningRate)

        iteration += 1
    } while iteration < 100_000_000

    return (theta, iteration)
}

func main() {
    let result: Vector = Vector(data: [1.5, 3, 4.5])
    let data: Matrix = Matrix(data: [1, 1, 1, 2, 1, 3,],
                              rows: 3,
                              columns: 2)

    let learningRate: Double = 0.01
    let theta: Vector = Vector(data: [0, 0])

    let t0 = DispatchTime.now().uptimeNanoseconds

    let (finalTheta, iteration) = gradientDescent(theta,
                                                  data,
                                                  result,
                                                  learningRate)

    let t1 = DispatchTime.now().uptimeNanoseconds

    let totalTime = Double(t1 - t0) / 1e6
    print("Result: \(finalTheta), iteration \(iteration), time: \(totalTime)")

    print("Test")
    for i in 0..<result.count {
        let predicted = data[i, 0] * finalTheta[0] + data[i, 1] * finalTheta[1]
        print("\(data[i, 0]) * \(finalTheta[0]) + \(data[i, 1]) * \(finalTheta[1]) = \(predicted) | \(result[i])")
    }
}

main()
