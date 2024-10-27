//
//  PlyUtil.swift
//  VoxelammingSwift
//
//  Created by user_name on 2024/10/28.
//

import Foundation

public struct BoxData: Hashable {
    public let x: Double
    public let y: Double
    public let z: Double
    public let r: Double
    public let g: Double
    public let b: Double
    public let alpha: Double

    public init(x: Double, y: Double, z: Double, r: Double, g: Double, b: Double, alpha: Double) {
        self.x = x
        self.y = y
        self.z = z
        self.r = r
        self.g = g
        self.b = b
        self.alpha = alpha
    }
}

@available(iOS 15.0, macOS 12.0, *)
public func getBoxesFromPly(_ plyFile: String) -> Set<BoxData> {
    print("getBoxesFromPly")
    var boxPositions = Set<BoxData>()

    let lines: [String] = plyFile.split(separator: "\n").map(String.init)
    let positions = lines
        .filter { isIncludedSixNumbers(line: $0) }
        .map { $0.split(separator: " ").compactMap { Double($0) } }

    let numberOfFaces = positions.count / 4
    print("numberOfFaces: \(numberOfFaces)")
    for i in 0..<numberOfFaces {
        let vertex1 = positions[i * 4]
        let vertex2 = positions[i * 4 + 1]
        let vertex3 = positions[i * 4 + 2]
        // let vertex4 = positions[i * 4 + 3]  // 使用しない場合はコメントアウト
        var x: Double = min(vertex1[0], vertex2[0], vertex3[0])
        var y: Double = min(vertex1[1], vertex2[1], vertex3[1])
        var z: Double = min(vertex1[2], vertex2[2], vertex3[2])
        let r: Double = vertex1[3] / 255
        let g: Double = vertex1[4] / 255
        let b: Double = vertex1[5] / 255
        let alpha: Double = 1.0
        var step: Double = 0

        // ボックスを置く方向を解析
        if vertex1[0] == vertex2[0] && vertex2[0] == vertex3[0] {  // y-z 平面
            step = max(vertex1[1], vertex2[1], vertex3[1]) - y
            if vertex1[1] != vertex2[1] {
                x -= step
            }
        } else if vertex1[1] == vertex2[1] && vertex2[1] == vertex3[1] {  // z-x 平面
            step = max(vertex1[2], vertex2[2], vertex3[2]) - z
            if vertex1[2] != vertex2[2] {
                y -= step
            }
        } else {  // x-y 平面
            step = max(vertex1[0], vertex2[0], vertex3[0]) - x
            if vertex1[0] != vertex2[0] {
                z -= step
            }
        }

        // 最小単位: 0.1
        let positionX = floor(round(x * 10.0 / step) / 10.0)
        let positionY = floor(round(y * 10.0 / step) / 10.0)
        let positionZ = floor(round(z * 10.0 / step) / 10.0)
        // print("x: \(positionX), y: \(positionY), z: \(positionZ)")
        let position = BoxData(x: positionX, y: positionZ, z: -positionY, r: r, g: g, b: b, alpha: alpha)
        boxPositions.insert(position)
    }

    return boxPositions
}

public func isIncludedSixNumbers(line: String) -> Bool {
    let lineList = line.split(separator: " ")
    if lineList.count != 6 {
        return false
    }
    for item in lineList {
        if Double(item) != nil {
            continue
        } else {
            return false
        }
    }
    return true
}
