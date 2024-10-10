# VoxelammingSwift

VoxelammingSwiftは、開発者がプログラムによってボクセルベースの3D AR体験を作成できるSwiftパッケージです。WebSocket経由でVoxelamming ARアプリと通信することで、Swiftコードを使用して拡張現実環境内でボクセル（3Dキューブ）を配置および操作できます。

<p align="center">
  <img src="https://creativival.github.io/voxelamming/image/voxelamming_icon.png" alt="Voxelamming Logo" width="200"/>
</p>

## VoxelammingSwiftとは？

VoxelammingSwiftは、拡張現実を通じて視覚的かつインタラクティブにプログラミングの概念を学習・教育できるようにします。Voxelammingアプリとシームレスに連携するよう設計されており、iOS 16以降を搭載したiPhoneおよびiPadをサポートしています。

**対象ユーザー:**

- **プログラミング学習者:** ARで即時の視覚的フィードバックを得ながらプログラミングの基本を理解できます。
- **ジェネレーティブアーティスト:** コードとAR技術を使用して複雑な3Dアートワークを作成できます。

## 特徴

- **直感的なAR統合:** 現実世界にボクセルを配置して空間認識を高めます。
- **使いやすいAPI:** ボクセルの作成、変換、アニメーションをシンプルなメソッドで実現。
- **リアルタイム通信:** WebSocketを使用してコードとARアプリ間で即時に更新を反映。
- **クロスプラットフォーム開発:** macOSでコードを書いてiOSデバイスと連携。

## インストール

XcodeプロジェクトにVoxelammingSwiftを追加するには：

1. **Swiftパッケージマネージャー（推奨）：**

   - Xcodeプロジェクトを開きます。
   - **「ファイル」 > 「パッケージを追加...」** を選択します。
   - リポジトリのURLを入力します：

     ```
     https://github.com/creativival/VoxelammingSwift.git
     ```

   - バージョンを選択し、パッケージをプロジェクトに追加します。

2. **手動インストール：**

   - リポジトリをクローンします。
   - `VoxelammingSwift` フォルダをXcodeプロジェクトにドラッグ＆ドロップします。

## 使用方法

### 1. デバイスの準備

- **Voxelammingアプリをダウンロード：**
  - [App Storeリンク](https://apps.apple.com/jp/app/ボクセラミング/id6451427658?itsct=apps_box_link&itscg=30200)
- **平面アンカーを設定：**
  - アプリを起動し、画面の指示に従って現実世界にアンカーを配置します。
- **ルーム名を確認：**
  - アプリに表示されるルーム名は、接続を確立するために必要です。

### 2. Swiftコードを書く

VoxelammingSwiftパッケージをインポートし、ルーム名を使用してインスタンスを作成します。

```swift
import VoxelammingSwift

@available(iOS 15.0, macOS 12.0, *)
func exampleUsage() async throws {
    let voxelamming = Voxelamming(roomName: "your_room_name")
    voxelamming.setBoxSize(2.0) // ボクセルサイズを2倍に設定
    voxelamming.createBox(10, 5, -2, r: 1, g: 0, b: 0) // 赤いボクセルを配置
    try await voxelamming.sendData(name: "MyFirstVoxel")
}

### 3. コードを実行

- MacとiOSデバイスが同じネットワーク上にあることを確認します。
- Swiftコードを実行して、AR環境でボクセルが表示されるのを確認します。

## メソッドの説明

VoxelammingSwiftで使用可能な主要なメソッド一覧：

- **初期化：**
  - `init(roomName: String)`: 指定されたルーム名で接続を初期化します。

- **ボクセルの操作：**
  - `setBoxSize(_ boxSize: Double)`: ボクセルのサイズを設定します（デフォルトは `1.0`）。
  - `createBox(_ x: Double, _ y: Double, _ z: Double, r: Double = 1, g: Double = 1, b: Double = 1, alpha: Double = 1, texture: String = "")`: 指定された座標に色またはテクスチャ付きのボクセルを配置します。
  - `removeBox(_ x: Double, _ y: Double, _ z: Double)`: 指定された座標のボクセルを削除します。
  - `drawLine(_ x1: Double, _ y1: Double, _ z1: Double, _ x2: Double, _ y2: Double, _ z2: Double, r: Double = 1, g: Double = 1, b: Double = 1, alpha: Double = 1)`: 2点間にボクセルでラインを描画します。

- **変換とアニメーション：**
  - `transform(_ x: Double, _ y: Double, _ z: Double, pitch: Double = 0, yaw: Double = 0, roll: Double = 0)`: 座標系を平行移動および回転します。
  - `animate(_ x: Double, _ y: Double, _ z: Double, pitch: Double = 0, yaw: Double = 0, roll: Double = 0, scale: Double = 1, interval: Double = 10)`: 指定したパラメータでボクセルをアニメーション化します。
  - `animateGlobal(_ x: Double, _ y: Double, _ z: Double, pitch: Double = 0, yaw: Double = 0, roll: Double = 0, scale: Double = 1, interval: Double = 10)`: すべてのボクセルに対してグローバルにアニメーションを適用します。

- **高度な機能：**
  - `pushMatrix()`: 現在の変換マトリックスを保存します。
  - `popMatrix()`: 最後に保存した変換マトリックスを復元します。
  - `setLight(...)`: シーンに照明効果を追加します。
  - `createModel(...)`: AR環境にビルトインの3Dモデルを配置します。
  - `moveModel(...)`: ARシーン内で既存のモデルを移動します。

- **通信：**
  - `sendData(name: String = "")`: 現在のボクセルデータをVoxelammingアプリに送信します。オプションで `name` を指定して状態を保存できます。
  - `clearData()`: 現在のセッションからすべてのボクセルデータをクリアします。

各メソッドの詳細な使用方法については、[ドキュメント](#)を参照してください。

## ライセンス

このプロジェクトは [MITライセンス](LICENSE) の下でライセンスされています。

## お問い合わせ

ご質問やサポートが必要な場合は、[GitHubリポジトリ](https://github.com/creativival/VoxelammingSwift/issues)でイシューをオープンしてください。

---

