#if os(Windows)
import WinSDK
#else 
import Foundation
#endif

// https://saturncloud.io/blog/how-to-implement-linear-regression-using-batch-gradient-descent/#:~:text=Linear%20regression%20is%20a%20fundamental,of%20a%20machine%20learning%20model.

func prediction(_ X: Matrix, _ theta: Vector) -> Vector {
    X * theta
}

func mse(predY: Vector, trueY: Vector) -> Double {
    let diff = (trueY - predY)
    let error = diff * diff
    return error.sum() / Double(error.count)
}

func train(
    _ theta: Vector,
    _ data: Matrix,
    _ originalY: Vector,
    _ learningRate: Double,
    iterations: Int = 1_000_000
) -> Vector {
    var theta = theta
    
    for i in 0..<iterations {
        let predY = prediction(data, theta)
        let cost = mse(predY: predY, trueY: originalY)
        let gradient = (data.transpose * (predY - originalY)) * (2.0 / Double(originalY.count))
        theta = theta - gradient * learningRate
        print("Iteration: \(i) - theta \(theta) error \(cost) - gradient \(gradient)")
    }

    return theta
}

@main
struct Linear {
    static func main() {
        var originalY: Vector = .init(data: [])
        var originalX: Matrix = .init(rows: 100, columns: 2, data: [])
        var testData: Matrix = .init(rows: 100, columns: 2, data: [])
        for _ in 0..<100 {
            let x = Double.random(in: -1.0...1.0) * 30.0
            let y = -x + 3.0 * Double.random(in: -1.0...1.0)
            originalX.data.append(x)
            originalX.data.append(1) // Add 1 for the yOffset calculation later

            originalY.data.append(y)

            testData.data.append(x)
            testData.data.append(y)
        }
        
        let learningRate: Double = 0.001
        let theta: Vector = Vector(data: [1.3, 3.1])
        
        let t0 = DispatchTime.now().uptimeNanoseconds
        let finalTheta = train(theta, originalX, originalY, learningRate, iterations: 20000)
        let t1 = DispatchTime.now().uptimeNanoseconds
        
        let totalTime = Double(t1 - t0) / 1e6
        print("Result: \(finalTheta), time: \(totalTime)")
        
        chart(title: "Linear", data: testData, size: CGRect(origin: .zero, size: .init(width: 1024, height: 1024)), parameters: finalTheta, original: theta)
    }
}
