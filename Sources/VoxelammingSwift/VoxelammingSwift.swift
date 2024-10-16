// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@available(iOS 15.0, macOS 12.0, *)
public class VoxelammingSwift: NSObject {
    let url = URL(string: "wss://websocket.voxelamming.com")!
    var webSocketTask: URLSessionWebSocketTask?
    let textureNames = ["grass", "stone", "dirt", "planks", "bricks"]
    let modelNames = ["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune", "Pluto", "Sun",
            "Moon", "ToyBiplane", "ToyCar", "Drummer", "Robot", "ToyRocket", "RocketToy1", "RocketToy2", "Skull"]
    var roomName = ""
    var isAllowedMatrix: Int = 0
    var savedMatrices: [[Double]] = []
    var matrixTransform: [Double] = [0, 0, 0, 0, 0, 0]
    var isFraming = false
    var frameId: Int = 0
    var rotationStyles: [String: String] = [:] // 回転の制御（送信しない）
    // アイドルタイマーとタイムアウト設定
    var idleTimer: DispatchSourceTimer?
    let idleTimeout: TimeInterval = 3.0 // 3秒間アイドル状態が続いたら接続を閉じる
    // 送信データ
    public var nodeTransform: [Double] = [0, 0, 0, 0, 0, 0]
    public var frameTransforms: [[Double]] = []
    public var globalAnimation: [Double] = [0, 0, 0, 0, 0, 0, 1, 0]
    public var animation: [Double] = [0, 0, 0, 0, 0, 0, 1, 0]
    public var boxes = [[Double]]()
    public var frames = [[Double]]()
    public var sentences = [[String]]()
    public var lights = [[Double]]()
    public var commands = [String]()
    public var models = [[String]]()
    public var modelMoves = [[String]]()
    public var sprites = [[String]]()
    public var spriteMoves = [[String]]()
    public var gameScore = [Double]()
    public var gameScreen = [Double]() // width, height, angle=90, red=1, green=0, blue=1, alpha=0.3
    public var size: Double = 1.0
    public var shape: String = "box"
    public var buildInterval = 0.01
    public var isMetallic: Int = 0
    public var roughness: Double = 0.5
    public var isAllowedFloat: Int = 0
    public var name: String = "" // アプリ内ののコードエディタ用
    public var date: String = "" // アプリ内ののコードエディタ用

    public init(roomName: String = "") {
        self.roomName = roomName
        super.init()
    }

    public func clearData() {
        isAllowedMatrix = 0
        savedMatrices = []
        matrixTransform = [0, 0, 0, 0, 0, 0]
        isFraming = false
        frameId = 0
        rotationStyles = [:]
        nodeTransform = [0, 0, 0, 0, 0, 0]
        frameTransforms = []
        globalAnimation = [0, 0, 0, 0, 0, 0, 1, 0]
        animation = [0, 0, 0, 0, 0, 0, 1, 0]
        boxes = []
        frames = []
        sentences = []
        lights = []
        commands = []
        models = []
        modelMoves = []
        sprites = []
        spriteMoves = []
        size = 1.0
        shape = "box"
        buildInterval = 0.01
        isMetallic = 0
        roughness = 0.5
        isAllowedFloat = 0
        name = ""
        date = ""
    }

    public func setFrameFPS(_ fps: Int = 2) {
        commands.append("fps \(fps)")
    }

    public func setFrameRepeats(_ repeats: Int = 10) {
        commands.append("repeats \(repeats)")
    }

    public func frameIn() {
        isFraming = true
    }

    public func frameOut() {
        isFraming = false
        frameId += 1
    }

    public func pushMatrix() {
        self.isAllowedMatrix += 1
        self.savedMatrices.append(matrixTransform)
    }

    public func popMatrix() {
        self.isAllowedMatrix -= 1
        matrixTransform = self.savedMatrices.popLast()!
    }

    public func transform(_ x: Double, _ y: Double, _ z: Double, pitch: Double = 0, yaw: Double = 0, roll: Double = 0) {
        if self.isAllowedMatrix > 0 {
            // Retrieve the saved matrix
            let matrix = self.savedMatrices.last!
            let basePosition = Array(matrix[0...2])

            let baseRotationMatrix: [[Double]]
            if matrix.count == 6 {
                baseRotationMatrix = getRotationMatrix(pitch: matrix[3], yaw: matrix[4], roll: matrix[5])
            } else {
                baseRotationMatrix = [
                    Array(matrix[3...5]),
                    Array(matrix[6...8]),
                    Array(matrix[9...11])
                ]
            }

            // Calculate the position after the move
            let (addX, addY, addZ) = transformPointByRotationMatrix(point: (Double(x), Double(y), Double(z)), R: transpose3x3(matrix: baseRotationMatrix))
            let addedVectorList = addVectors(vector1: basePosition, vector2: [Double(addX), Double(addY), Double(addZ)])
            let newX = addedVectorList[0]
            let newY = addedVectorList[1]
            let newZ = addedVectorList[2]
            let roundNumList = roundNumbers(numList: [Double(newX), Double(newY), Double(newZ)])
            let roundX = roundNumList[0]
            let roundY = roundNumList[1]
            let roundZ = roundNumList[2]

            // Calculate the rotation after the move
            // inverse rotation
            let translateRotationMatrix = getRotationMatrix(pitch: -pitch, yaw: -yaw, roll: -roll)
            let rotatedMatrix = matrixMultiply(A: translateRotationMatrix, B: baseRotationMatrix)

            matrixTransform = [roundX, roundY, roundZ] + rotatedMatrix.flatMap { $0 }
        } else {
            let roundNumList = roundNumbers(numList: [x, y, z])
            let roundX = roundNumList[0]
            let roundY = roundNumList[1]
            let roundZ = roundNumList[2]

            let roundRotationList = roundTwoDecimals(numList: [pitch, yaw, roll])
            let roundPitch = roundRotationList[0]
            let roundYaw = roundRotationList[1]
            let roundRoll = roundRotationList[2]

            if isFraming {
                frameTransforms.append([roundX, roundY, roundZ, roundPitch, roundYaw, roundRoll, Double(frameId)])
            } else {
                self.nodeTransform = [roundX, roundY, roundZ, roundPitch, roundYaw, roundRoll]
            }
        }
    }

    public func createBox(_ x: Double, _ y: Double, _  z: Double, r: Double = 1, g: Double = 1, b: Double = 1, alpha: Double = 1, texture: String = "") {
        var x = x
        var y = y
        var z = z

        if self.isAllowedMatrix > 0 {
            // Retrieve the saved matrix
            let matrix = matrixTransform
            let basePosition = Array(matrix[0...2])

            let baseRotationMatrix: [[Double]]
            if matrix.count == 6 {
                baseRotationMatrix = getRotationMatrix(pitch: matrix[3], yaw: matrix[4], roll: matrix[5])
            } else {
                baseRotationMatrix = [
                    Array(matrix[3...5]),
                    Array(matrix[6...8]),
                    Array(matrix[9...11])
                ]
            }

            // Calculate the position after the move
            let (addX, addY, addZ) = transformPointByRotationMatrix(point: (Double(x), Double(y), Double(z)), R: transpose3x3(matrix: baseRotationMatrix))
            let addedVectorList = addVectors(vector1: basePosition, vector2: [Double(addX), Double(addY), Double(addZ)])
            x = addedVectorList[0]
            y = addedVectorList[1]
            z = addedVectorList[2]
        }

        let roundNumList = roundNumbers(numList: [x, y, z])
        let roundX = roundNumList[0]
        let roundY = roundNumList[1]
        let roundZ = roundNumList[2]
        let roundColorList = roundTwoDecimals(numList: [r, g, b, alpha])
        let roundR = roundColorList[0]
        let roundG = roundColorList[1]
        let roundB = roundColorList[2]
        let roundAlpha = roundColorList[3]

        // 重ねて置くことを防止するために、同じ座標の箱があれば削除する
        removeBox(roundX, roundY, roundZ)

        let textureId: Int
        if textureNames.contains(texture) {
            textureId = textureNames.firstIndex(of: texture) ?? -1
        } else {
            textureId = -1
        }

        if isFraming {
            frames.append([roundX, roundY, roundZ, roundR, roundG, roundB, roundAlpha, Double(textureId), Double(frameId)])
        } else {
            boxes.append([x, y, z, r, g, b, alpha, Double(textureId)])
        }
    }

    public func removeBox(_ x: Double, _ y: Double, _ z: Double) {
        let roundNumList = roundNumbers(numList: [x, y, z])
        let roundX = roundNumList[0]
        let roundY = roundNumList[1]
        let roundZ = roundNumList[2]

        if isFraming {
            frames.removeAll { frame in
                frame[0] == roundX && frame[1] == roundY && frame[2] == roundZ && frame[8] == Double(frameId)
            }
        } else {
            boxes.removeAll { box in
                box[0] == roundX && box[1] == roundY && box[2] == roundZ
            }
        }
    }

    public func animateGlobal(_ x: Double, _ y: Double, _  z: Double, pitch: Double = 0, yaw: Double = 0, roll: Double = 0, scale: Double = 1, interval: Double = 10) {
        let roundNumList = roundNumbers(numList: [x, y, z])
        let roundX = roundNumList[0]
        let roundY = roundNumList[1]
        let roundZ = roundNumList[2]
        globalAnimation = [roundX, roundY, roundZ, pitch, yaw, roll, scale, interval]
    }

    public func animate(_ x: Double, _ y: Double, _  z: Double, pitch: Double = 0, yaw: Double = 0, roll: Double = 0, scale: Double = 1, interval: Double = 10) {
        let roundNumList = roundTwoDecimals(numList: [x, y, z, pitch, yaw, roll, scale, interval])
        let roundX = roundNumList[0]
        let roundY = roundNumList[1]
        let roundZ = roundNumList[2]
        let roundPitch = roundNumList[3]
        let roundYaw = roundNumList[4]
        let roundRoll = roundNumList[5]
        let roundScale = roundNumList[6]
        let roundInterval = roundNumList[7]
        animation = [roundX, roundY, roundZ, roundPitch, roundYaw, roundRoll, roundScale, roundInterval]
    }

    public func setBoxSize(_ boxSize: Double) {
        size = boxSize
    }

    public func setBuildInterval(_ interval: Double) {
        buildInterval = interval
    }

    public func writeSentence(_ string_sentence: String, _ x: Double, _ y: Double, _  z: Double, r: Double = 0, g: Double = 0, b: Double = 0, alpha: Double = 1, fontSize: Int = 16, isFixedWidth: Bool = false) {
        let roundNumList = roundNumbers(numList: [x, y, z])
        let roundX = roundNumList[0]
        let roundY = roundNumList[1]
        let roundZ = roundNumList[2]
        let roundColorList = roundTwoDecimals(numList: [r, g, b, alpha])
        let roundR = roundColorList[0]
        let roundG = roundColorList[1]
        let roundB = roundColorList[2]
        let roundAlpha = roundColorList[3]
        let stringX = String(roundX)
        let stringY = String(roundY)
        let stringZ = String(roundZ)
        let stringR = String(roundR)
        let stringG = String(roundG)
        let stringB = String(roundB)
        let stringAlpha = String(roundAlpha)
        let stringFontSize = String(fontSize)

        // 固定幅のフラグを文字列に変換
        let stringIsFixedWidth = isFixedWidth ? "1" : "0"

        sentences.append([string_sentence, stringX, stringY, stringZ, stringR, stringG, stringB, stringAlpha, stringFontSize, stringIsFixedWidth])
    }

    public func setLight(_ x: Double, _ y: Double, _  z: Double, r: Double = 0, g: Double = 0, b: Double = 0, alpha: Double = 1, intensity: Double = 1000, interval: Double = 1, lightType: String = "point") {
        let roundNumList = roundNumbers(numList: [x, y, z])
        let roundX = roundNumList[0]
        let roundY = roundNumList[1]
        let roundZ = roundNumList[2]
        let roundColorList = roundTwoDecimals(numList: [r, g, b, alpha])
        let roundR = roundColorList[0]
        let roundG = roundColorList[1]
        let roundB = roundColorList[2]
        let roundAlpha = roundColorList[3]
        var doubleLightType: Double

        if lightType == "point" {
            doubleLightType = 1
        } else if lightType == "spot" {
            doubleLightType = 2
        } else if lightType == "directional" {
            doubleLightType = 3
        } else {
            doubleLightType = 1
        }
        lights.append([roundX, roundY, roundZ, roundR, roundG, roundB, roundAlpha, intensity, interval, doubleLightType])
    }

    public func setCommand(_ command: String) {
        commands.append(command)

        if command == "float" {
            isAllowedFloat = 1
        }
    }

    public func drawLine(_ x1: Double, _ y1: Double, _ z1: Double, _ x2: Double, _ y2: Double, _ z2: Double, r: Double = 1, g: Double = 1, b: Double = 1, alpha: Double = 1) {
        let x1 = floor(x1)
        let y1 = floor(y1)
        let z1 = floor(z1)
        let x2 = floor(x2)
        let y2 = floor(y2)
        let z2 = floor(z2)
        let diffX = x2 - x1
        let diffY = y2 - y1
        let diffZ = z2 - z1
        let maxLength = max(abs(diffX), abs(diffY), abs(diffZ))

        if diffX == 0 && diffY == 0 && diffZ == 0 {
            return
        }

        if abs(diffX) == maxLength {
            if x2 > x1 {
                for x in Int(x1)...Int(x2) {
                    let y = y1 + (Double(x) - x1) * diffY / diffX
                    let z = z1 + (Double(x) - x1) * diffZ / diffX
                    createBox(Double(x), y, z, r: r, g: g, b: b, alpha: alpha)
                }
            } else {
                for x in stride(from: Int(x1), through: Int(x2), by: -1) {
                    let y = y1 + (Double(x) - x1) * diffY / diffX
                    let z = z1 + (Double(x) - x1) * diffZ / diffX
                    createBox(Double(x), y, z, r: r, g: g, b: b, alpha: alpha)
                }
            }
        } else if abs(diffY) == maxLength {
            if y2 > y1 {
                for y in Int(y1)...Int(y2) {
                    let x = x1 + (Double(y) - y1) * diffX / diffY
                    let z = z1 + (Double(y) - y1) * diffZ / diffY
                    createBox(x, Double(y), z, r: r, g: g, b: b, alpha: alpha)
                }
            } else {
                for y in stride(from: Int(y1), through: Int(y2), by: -1) {
                    let x = x1 + (Double(y) - y1) * diffX / diffY
                    let z = z1 + (Double(y) - y1) * diffZ / diffY
                    createBox(x, Double(y), z, r: r, g: g, b: b, alpha: alpha)
                }
            }
        } else if abs(diffZ) == maxLength {
            if z2 > z1 {
                for z in Int(z1)...Int(z2) {
                    let x = x1 + (Double(z) - z1) * diffX / diffZ
                    let y = y1 + (Double(z) - z1) * diffY / diffZ
                    createBox(x, y, Double(z), r: r, g: g, b: b, alpha: alpha)
                }
            } else {
                for z in stride(from: Int(z1), through: Int(z2), by: -1) {
                    let x = x1 + (Double(z) - z1) * diffX / diffZ
                    let y = y1 + (Double(z) - z1) * diffY / diffZ
                    createBox(x, y, Double(z), r: r, g: g, b: b, alpha: alpha)
                }
            }
        }
    }

    public func createModel(modelName: String, x: Double = 0, y: Double = 0, z: Double = 0, pitch: Double = 0, yaw: Double = 0, roll: Double = 0, scale: Double = 1, entityName: String = "") {
        if modelNames.contains(modelName) {
            print("Find model name: \(modelName)")
            let roundedValues = roundTwoDecimals(numList: [x, y, z, pitch, yaw, roll, scale])
            let stringValues = roundedValues.map { String($0) }

            let modelEntry = [modelName] + stringValues + [entityName]
            models.append(modelEntry)
        } else {
            print("No model name: \(modelName)")
        }
    }

    public func moveModel(entityName: String, x: Double = 0, y: Double = 0, z: Double = 0, pitch: Double = 0, yaw: Double = 0, roll: Double = 0, scale: Double = 1) {
        let roundedValues = roundTwoDecimals(numList: [x, y, z, pitch, yaw, roll, scale])
        let stringValues = roundedValues.map { String($0) }

        let moveEntry = [entityName] + stringValues
        modelMoves.append(moveEntry)
    }

    public func changeShape(_ shape: String) {
        self.shape = shape
    }

    public func changeMaterial(isMetallic: Bool = false, roughness: Double = 0.5) {
        self.isMetallic = isMetallic ? 1 : 0
        self.roughness = roughness
    }

    // Game API

    public func setGameScreen(width: Double, height: Double, angle: Double = 90, red: Double = 1, green: Double = 1, blue: Double = 0, alpha: Double = 0.5) {
        gameScreen = [width, height, angle, red, green, blue, alpha]
    }

    public func setGameScore(score: Double, x: Double = 0, y: Double = 0) {
        gameScore = [score, x, y]
    }

    public func sendGameOver() {
        commands.append("gameOver")
    }

    public func sendGameClear() {
        commands.append("gameClear")
    }

    public func setRotationStyle(spriteName: String, rotationStyle: String = "all around") {
        rotationStyles[spriteName] = rotationStyle
    }

    // Create sprite template (sprite is not placed)
    public func createSpriteTemplate(spriteName: String, colorList: [String]) {
        sprites.append([spriteName] + colorList)
    }

    // Display multiple sprites using the template
    public func displaySpriteTemplate(spriteName: String, x: Double, y: Double, direction: Double = 0, scale: Double = 1) {
        // Round x, y, and direction
        let roundedValues = roundNumbers(numList: [x, y, direction])
        let stringValues = roundedValues.map { String($0) }
        let roundedX = roundedValues[0]
        let roundedY = roundedValues[1]
        let roundedDirection = roundedValues[2]
        var directionStr = stringValues[2]

        // Get rotation style
        if let rotationStyle = rotationStyles[spriteName] {
            switch rotationStyle {
            case "left-right":
                let directionMod = roundedDirection.truncatingRemainder(dividingBy: 360)
                if directionMod > 90 && directionMod < 270 {
                    directionStr = "-180"
                } else {
                    directionStr = "0"
                }
            case "don't rotate":
                directionStr = "0"
            default:
                break
            }
        }

        // Find the specified sprite name in spriteMoves
        if let index = spriteMoves.firstIndex(where: { $0[0] == spriteName }) {
            spriteMoves[index] += [String(roundedX), String(roundedY), directionStr, String(scale)]
        } else {
            spriteMoves.append([spriteName, String(roundedX), String(roundedY), directionStr, String(scale)])
        }
    }

    // Create a regular sprite
    public func createSprite(spriteName: String, colorList: [String], x: Double = 0, y: Double = 0, direction: Double = 0, scale: Double = 1, visible: Bool = true) {
        // (Step 1) Add the sprite template data to the array (it will not be displayed yet)
        createSpriteTemplate(spriteName: spriteName, colorList: colorList)

        // (Step 2) If the sprite should be visible, add the sprite move data to the array
        if visible || x != 0 || y != 0 || direction != 0 || scale != 1 {
            let roundedValues = roundNumbers(numList: [x, y, direction])
            let roundedX = roundedValues[0]
            let roundedY = roundedValues[1]
            let roundedDirection = roundedValues[2]
            spriteMoves.append([spriteName, String(roundedX), String(roundedY), String(roundedDirection), String(scale)])
        }
    }

    // Move a regular sprite
    public func moveSprite(spriteName: String, x: Double, y: Double, direction: Double = 0, scale: Double = 1, visible: Bool = true) {
        if visible {
            displaySpriteTemplate(spriteName: spriteName, x: x, y: y, direction: direction, scale: scale)
        }
    }

    // Move a sprite clone
    public func moveSpriteClone(spriteName: String, x: Double, y: Double, direction: Double = 0, scale: Double = 1) {
        displaySpriteTemplate(spriteName: spriteName, x: x, y: y, direction: direction, scale: scale)
    }

    // Display a dot (bullet)
    public func displayDot(x: Double, y: Double, direction: Double = 0, colorId: Int = 10, width: Int = 1, height: Int = 1) {
        let templateName = "dot_\(colorId)_\(width)_\(height)"
        displaySpriteTemplate(spriteName: templateName, x: x, y: y, direction: direction, scale: 1)
    }

    // Display text
    public func displayText(text: String, x: Double, y: Double, direction: Double = 0, scale: Double = 1, colorId: Int = 7, isVertical: Bool = false, align: String = "") {
        // Determine text format based on alignment
        var textFormat = ""
        if align.lowercased().contains("top") {
            textFormat += "t"
        } else if align.lowercased().contains("bottom") {
            textFormat += "b"
        }
        if align.lowercased().contains("left") {
            textFormat += "l"
        } else if align.lowercased().contains("right") {
            textFormat += "r"
        }

        textFormat += isVertical ? "v" : "h"
        let templateName = "text_\(text)_\(colorId)_\(textFormat)"
        displaySpriteTemplate(spriteName: templateName, x: x, y: y, direction: direction, scale: scale)
    }

    // アプリ内ののコードエディタからデータ送信するときに使用する
    public func setDataName(name: String) {
        let date = Date()
        let dateFormatter = ISO8601DateFormatter()
        let dateString = dateFormatter.string(from: date)
        self.name = name
        self.date = dateString
    }
    
    // sleep seconds function
    public func sleepSeconds(_ seconds: Double) async throws {
        // 秒をナノ秒に変換（1秒 = 1,000,000,000ナノ秒）
        let nanoseconds = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: nanoseconds)
    }
    
    // データを送信する関数
    public func sendData(name: String = "") async throws {
        try await ensureConnection()

        let date = Date()
        let dateFormatter = ISO8601DateFormatter()
        let dateString = dateFormatter.string(from: date)
        let dataDict = [
            "nodeTransform": nodeTransform,
            "frameTransforms": frameTransforms,
            "globalAnimation": globalAnimation,
            "animation": animation,
            "boxes": boxes,
            "frames": frames,
            "sentences": sentences,
            "lights": lights,
            "commands": commands,
            "models": models,
            "modelMoves": modelMoves,
            "sprites": sprites,
            "spriteMoves": spriteMoves,
            "gameScore": gameScore,
            "gameScreen": gameScreen,
            "size": size,
            "shape": shape,
            "interval": buildInterval,
            "isMetallic": isMetallic,
            "roughness": roughness,
            "isAllowedFloat": isAllowedFloat,
            "name": name,
            "date": dateString
        ] as [String : Any]

        let jsonData = try JSONSerialization.data(withJSONObject: dataDict, options: [])
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("Failed to convert data to string")
            return
        }

        if let webSocketTask = webSocketTask {
            try await webSocketTask.send(.string(jsonString))
            print("Sent message: \(jsonString)")
        } else {
            print("WebSocket connection is not available.")
        }

        // アイドルタイマーをリセット
        resetIdleTimer()
    }

    // 接続を確立または再利用するための関数
    private func ensureConnection() async throws {
        if webSocketTask == nil || webSocketTask?.state != .running || webSocketTask?.state == .completed || webSocketTask?.state == .canceling {
            // 新しい接続を確立
            webSocketTask = URLSession.shared.webSocketTask(with: url)
            webSocketTask?.resume()
            // 部屋名を送信
            if let webSocketTask = webSocketTask {
                try await webSocketTask.send(.string(roomName))
                print("Joined room: \(roomName)")
            }
        }
        // アイドルタイマーをリセット
        resetIdleTimer()
    }

    // アイドルタイマーをリセットする関数
    private func resetIdleTimer() {
        idleTimer?.cancel()
        idleTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        idleTimer?.schedule(deadline: .now() + idleTimeout)
        idleTimer?.setEventHandler { [weak self] in
            self?.closeConnection()
        }
        idleTimer?.resume()
    }

    // 接続を閉じる関数
    private func closeConnection() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        idleTimer?.cancel()
        idleTimer = nil
        print("WebSocket connection closed due to inactivity.")
    }

    private func roundNumbers(numList: [Double]) -> [Double] {
        if isAllowedFloat == 1 {
            return numList.map { round($0 * 100) / 100 }
        } else {
            return numList.map { round($0 * 10) / 10 }.map { floor($0) }
        }
    }

    private func roundTwoDecimals(numList: [Double]) -> [Double] {
        return numList.map { round($0 * 100) / 100 }
    }

    private func getRotationMatrix(pitch: Double, yaw: Double, roll: Double) -> [[Double]] {
        let pitch = pitch * .pi / 180.0
        let yaw = yaw * .pi / 180.0
        let roll = roll * .pi / 180.0

        // Pitch (rotation around X-axis)
        let Rx: [[Double]] = [
            [1, 0, 0],
            [0, cos(pitch), -sin(pitch)],
            [0, sin(pitch), cos(pitch)]
        ]

        // Yaw (rotation around Y-axis)
        let Ry: [[Double]] = [
            [cos(yaw), 0, sin(yaw)],
            [0, 1, 0],
            [-sin(yaw), 0, cos(yaw)]
        ]

        // Roll (rotation around Z-axis)
        let Rz: [[Double]] = [
            [cos(roll), -sin(roll), 0],
            [sin(roll), cos(roll), 0],
            [0, 0, 1]
        ]

        // Matrix multiplication: Rx x (Rz x Ry)
        let R = matrixMultiply(A: Rx, B: matrixMultiply(A: Rz, B: Ry))
        return R
    }

    private func matrixMultiply(A: [[Double]], B: [[Double]]) -> [[Double]] {
        var result: [[Double]] = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
        for i in 0..<3 {
            for j in 0..<3 {
                for k in 0..<3 {
                    result[i][j] += A[i][k] * B[k][j]
                }
            }
        }
        return result
    }

    private func transformPointByRotationMatrix(point: (Double, Double, Double), R: [[Double]]) -> (Double, Double, Double) {
        let (x, y, z) = point
        let x_new = R[0][0] * x + R[0][1] * y + R[0][2] * z
        let y_new = R[1][0] * x + R[1][1] * y + R[1][2] * z
        let z_new = R[2][0] * x + R[2][1] * y + R[2][2] * z
        return (x_new, y_new, z_new)
    }

    private func addVectors(vector1: [Double], vector2: [Double]) -> [Double] {
        return zip(vector1, vector2).map(+)
    }

    private func transpose3x3(matrix: [[Double]]) -> [[Double]] {
        return [
            [matrix[0][0], matrix[1][0], matrix[2][0]],
            [matrix[0][1], matrix[1][1], matrix[2][1]],
            [matrix[0][2], matrix[1][2], matrix[2][2]]
        ]
    }
}
