import XCTest
@testable import VoxelammingSwift

@available(iOS 15.0, macOS 12.0, *)
final class VoxelammingTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
        
        var voxelamming: VoxelammingSwift!

        func setUp() {
            super.setUp()
            // テストの前に呼ばれる
            voxelamming = VoxelammingSwift(roomName: "testRoom")
        }

        func tearDown() {
            // テストの後に呼ばれる
            voxelamming = nil
            super.tearDown()
        }

        func testSetGameScreen() {
            // ゲームスクリーンの設定をテスト
            voxelamming.setGameScreen(width: 1024, height: 768, angle: 45, red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
            XCTAssertEqual(voxelamming.gameScreen, [1024, 768, 45, 0.5, 0.5, 0.5, 1.0], "ゲームスクリーンの設定が正しくありません")
        }

        func testSetGameScore() {
            // ゲームスコアの設定をテスト
            voxelamming.setGameScore(score: 100, x: 50, y: 75)
            XCTAssertEqual(voxelamming.gameScore, [100, 50, 75], "ゲームスコアの設定が正しくありません")
        }

        func testSendGameOver() {
            // ゲームオーバーを送信する機能をテスト
            voxelamming.sendGameOver()
            XCTAssertTrue(voxelamming.commands.contains("gameOver"), "ゲームオーバーコマンドが送信されていません")
        }

        func testCreateSprite() {
            // スプライトの作成と表示をテスト
            voxelamming.createSprite(spriteName: "testSprite", colorList: ["red", "green"], x: 10, y: 20, direction: 30, scale: 2.0, visible: true)
            XCTAssertTrue(voxelamming.sprites.contains(where: { $0[0] == "testSprite" }), "スプライトが正しく作成されていません")
            XCTAssertTrue(voxelamming.spriteMoves.contains(where: { $0[0] == "testSprite" && $0[1] == "10" && $0[2] == "20" }), "スプライトの移動データが正しくありません")
        }

        func testClearData() {
            // データクリア機能をテスト
            voxelamming.setGameScore(score: 100)
            voxelamming.clearData()
            XCTAssertEqual(voxelamming.gameScore, [], "データが正しくクリアされていません")
        }
    }
}
