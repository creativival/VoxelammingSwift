//
//  mapUtil.swift
//  VoxelammingSwift
//
//  Created by user_name on 2024/10/28.
//

import Foundation

@available(iOS 15.0, macOS 12.0, *)
public func getMapDataFromCSV(csvFile: String, heightScale: Double, columnNum: Int = 257, rowNum: Int = 257) -> [String: Any] {
    var mapData: [String: Any] = [:]

    let rows = csvFile.split(separator: "\n")

    var heights: [Double] = []
    for h in rows[0].split(separator: ",") {
        let heightValue = Double(h) ?? 0.0
        heights.append(heightValue != 0.0 ? floor(heightValue * heightScale) : -1.0)
    }

    let maxHeight = floor(heights.max() ?? 0.0)
    print("max", maxHeight)

    var boxPositions: [[Double]] = []
    for i in 0..<rowNum {
        var row: [Double] = []
        for j in 0..<columnNum {
            row.append(heights[j + columnNum * i])
        }
        boxPositions.append(row)
    }

    mapData = ["boxes": boxPositions, "maxHeight": maxHeight]

    return mapData
}

public func getBoxColor(height: Double, maxHeight: Double, highColor: (Double, Double, Double), lowColor: (Double, Double, Double)) -> (Double, Double, Double) {
    let r = (highColor.0 - lowColor.0) * height / maxHeight + lowColor.0
    let g = (highColor.1 - lowColor.1) * height / maxHeight + lowColor.1
    let b = (highColor.2 - lowColor.2) * height / maxHeight + lowColor.2

    return (r, g, b)
}
