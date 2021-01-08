#if os(Windows)
import WinSDK
#else 
import Foundation
#endif

/// hm is the hypothesis that will produce an expected result
func hm(_ theta: [Double], x: [Double]) -> Double {
    theta[0] * x[0] + theta[1] * x[1]
}

/// J performs the mean squared error over the data
///
/// theta is an array of parameters that are changing
/// j is the theta that is being tested against the results
/// m is the training data count
/// data is an array of input values for theta
/// result is the expected result of the hypothesis
///
/// returns the sum difference of the hypothesis minus the result as an increment
func dJ(_ theta: [Double], j: Int, m: Int, data: [Double], result: [Double]) -> Double {
    var errorSum: Double = 0
    for i in 0..<m {
        let xi = data[i + j * m]
        let h0 = hm(theta, x: [data[i + (0) * m], data[i + (1) * m]])
        let diff = (h0 - result[i]) * xi
        errorSum += diff
    }

    return errorSum / Double(m)
}

func gradientDescent(_ theta: inout [Double], _ iter: inout Int, _ data: [Double], _ result: [Double], _ m: Int, _ rate: Double) {
    var prevError: [Double] = [-1, -1]

    repeat {
        var errorSquared: [Double] = [-1, -1]
        for j in 0..<theta.count {
            errorSquared[j] = dJ(theta, j: j, m: m, data: data, result: result)
        }
        print("Iteration: \(iter) - theta \(theta) error \(errorSquared)")

        if errorSquared[0].isNaN || theta[0].isNaN ||
            errorSquared[1].isNaN || theta[1].isNaN {
            break
        }

        var done = true

        for j in 0..<theta.count {
            if !errorSquared[j].isEqual(to: prevError[j]) {
                done = false
                break
            }
        }

        if done {
            break
        }

        prevError = errorSquared

        for j in 0..<theta.count {
            theta[j] -= errorSquared[j] * rate
        }
        iter += 1
    } while iter < 100_000_000
}

func main() {
    let result: [Double] = [1, 4, 7, 9, 11, 13, 15, 17]
    let data: [Double] = [1, 1, 1, 1, 1, 1, 1, 1, 
                          0, 1, 2, 3, 4, 5, 6, 7]
    let m = result.count
    let rate: Double = 0.001
    var theta: [Double] = [0, 0]
    var iter = 0

    let t0 = DispatchTime.now().uptimeNanoseconds
    
    gradientDescent(&theta, &iter, data, result, m, rate)
    
    let t1 = DispatchTime.now().uptimeNanoseconds

    let totalTime = Double(t1 - t0) / 1e6
    print("Result: \(theta), iter \(iter), time: \(totalTime)")
}

main()