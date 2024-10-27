//
//  Turtle.swift
//  VoxelammingSwift
//
//  Created by user_name on 2024/10/28.
//

import Foundation

@available(iOS 15.0, macOS 12.0, *)
public class Turtle {
    public var vox: VoxelammingSwift
    public var x: Double
    public var y: Double
    public var z: Double
    public var polarTheta: Double
    public var polarPhi: Double
    public var drawable: Bool
    public var color: [Double]
    public var size: Double

    public init(vox: VoxelammingSwift) {
        self.vox = vox
        self.x = 0
        self.y = 0
        self.z = 0
        self.polarTheta = 90
        self.polarPhi = 0
        self.drawable = true
        self.color = [0, 0, 0, 1]
        self.size = 1
    }

    public func forward(_ length: Double) {
        let radiansTheta = polarTheta * Double.pi / 180.0
        let radiansPhi = polarPhi * Double.pi / 180.0

        let z = self.z + length * sin(radiansTheta) * cos(radiansPhi)
        let x = self.x + length * sin(radiansTheta) * sin(radiansPhi)
        let y = self.y + length * cos(radiansTheta)
        let r: Double = self.color[0]
        let g: Double = self.color[1]
        let b: Double = self.color[2]
        let alpha: Double = self.color[3]

        let roundedX = round(x * 1000) / 1000
        let roundedY = round(y * 1000) / 1000
        let roundedZ = round(z * 1000) / 1000

        if drawable {
            vox.drawLine(self.x, self.y, self.z, roundedX, roundedY, roundedZ, r: r, g: g, b: b, alpha: alpha)
        }

        self.x = roundedX
        self.y = roundedY
        self.z = roundedZ
    }

    public func backward(_ length: Double) {
        forward(-length)
    }

    public func up(_ degree: Double) {
        polarTheta -= degree
    }

    public func down(_ degree: Double) {
        polarTheta += degree
    }

    public func right(_ degree: Double) {
        polarPhi -= degree
    }

    public func left(_ degree: Double) {
        polarPhi += degree
    }

    public func setColor(_ r: Double, _ g: Double, _ b: Double, _ alpha: Double) {
        color = [r, g, b, alpha]
    }

    public func penDown() {
        drawable = true
    }

    public func penUp() {
        drawable = false
    }

    public func setPos(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    public func reset() {
        x = 0
        y = 0
        z = 0
        polarTheta = 90
        polarPhi = 0
        drawable = true
        color = [0, 0, 0, 1]
        size = 1
    }
}
