import Foundation
import CoreGraphics
import AppKit

func chart(title: String, data: Matrix, size: CGRect, parameters: Vector, original: Vector) {
    guard data.columns == 2 else {
        print("data must have two columns, representing x and y positions")
        return
    }
    guard parameters.count == 2 else {
        print("too many parameters")
        return
    }
    
    guard let bitmap = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: Int(size.width),
        pixelsHigh: Int(size.height),
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: NSColorSpaceName.deviceRGB,
        bitmapFormat: .alphaFirst,
        bytesPerRow: Int(size.width) * 4,
        bitsPerPixel: 32
    ) else {
        return
    }
    
    let context = NSGraphicsContext(bitmapImageRep: bitmap)
    NSGraphicsContext.current = context
    
    guard let cgContext = context?.cgContext else { return }
    
    // Get bounds
    let x = data.column(0)
    let y = data.column(1)
    let minX = x.data.reduce(9999, { ($0 < $1) ? $0 : $1 } )
    let minY = y.data.reduce(9999, { ($0 < $1) ? $0 : $1 } )
    let maxX = x.data.reduce(-9999, { ($0 < $1) ? $1 : $0 } )
    let maxY = y.data.reduce(-9999, { ($0 < $1) ? $1 : $0 } )
    
    print("x \(minX), \(maxX) - y \(minY), \(maxY)")
    print("data.rows = \(data.rows)")
    
    let padding = 8.0
    let norm = { (xx: Double, yy: Double) -> (Double, Double) in
        let nx = (xx - minX) / (maxX - minX)
        let ny = (yy - minY) / (maxY - minY)
        let x1 = padding + nx * (size.width - padding * 2)
        let y1 = padding + ny * (size.height - padding * 2)
        
        return (x1, y1)
    }
    
    cgContext.setFillColor(CGColor.white)
    cgContext.fill(size)
    
    // Draw points
    var radius = 4.0
    cgContext.setStrokeColor(CGColor.init(red: 1, green: 0, blue: 0, alpha: 1))
    for i in 0..<data.rows {
        let (x, y) = norm(x[i], y[i])
        cgContext.strokeEllipse(in: CGRect(x: x - radius, y: y - radius, width: radius, height: radius))
    }

    cgContext.setStrokeColor(CGColor.init(red: 0, green: 0, blue: 0, alpha: 1))

    let predY = data * parameters
    let predOY = data * original

    var smallX = 99999.0
    var smalledIndex = -1
    var bigX = -99999.0
    var bigIndex = 100
    for i in 0..<100 {
        let x = data.column(0)[i]
        if x < smallX {
            smallX = x
            smalledIndex = i
        }
        if x > bigX {
            bigX = x
            bigIndex = i
        }
    }

    let left = norm(data.column(0)[smalledIndex], predY[smalledIndex])
    let right =  norm(data.column(0)[bigIndex], predY[bigIndex])
    
    cgContext.move(to: CGPoint(x: left.0, y: left.1))
    cgContext.addLine(to: CGPoint(x: right.0, y: right.1))
    cgContext.strokePath()

    let oleft = norm(data.column(0)[smalledIndex], predOY[smalledIndex])
    let oright =  norm(data.column(0)[bigIndex], predOY[bigIndex])
    
    cgContext.move(to: CGPoint(x: oleft.0, y: oleft.1))
    cgContext.addLine(to: CGPoint(x: oright.0, y: oright.1))
    cgContext.strokePath()
    
    // plot predicated
    cgContext.setStrokeColor(CGColor.init(red: 0, green: 0, blue: 1, alpha: 1))
    radius = 2
    for i in 0..<data.rows {
        let (x, y) = norm(data.column(0)[i], predY[i])
        cgContext.strokeEllipse(in: CGRect(x: x - radius, y: y - radius, width: radius, height: radius))
    }


    cgContext.setStrokeColor(CGColor.init(red: 0, green: 1, blue: 0, alpha: 1))
    radius = 2
    for i in 0..<data.rows {
        let (x, y) = norm(data.column(0)[i], predOY[i])
        cgContext.strokeEllipse(in: CGRect(x: x - radius, y: y - radius, width: radius, height: radius))
    }

    
    // Save file
    guard let data = bitmap.representation(using: .png, properties: [:]) else {
        fatalError("Failed to save to bitmap")
    }
    
    var path = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    path.appendPathComponent("chart-\(title.replacingOccurrences(of: " ", with: "_")).png")
    
    do {
        try data.write(to: path)
        print("File saved to \(path)")
        NSWorkspace.shared.open(path)
    } catch {
        fatalError(error.localizedDescription)
    }
}
