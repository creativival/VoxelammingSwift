# VoxelammingSwift

VoxelammingSwiftは、開発者がプログラムによってボクセルベースの3D AR体験を作成できるSwiftパッケージです。WebSocket経由でVoxelamming ARアプリと通信することで、Swiftコードを使用して拡張現実環境内でボクセル（3Dキューブ）を配置および操作できます。

<p align="center">
  <img src="https://creativival.github.io/voxelamming/image/voxelamming_icon.png" alt="Voxelamming Logo" width="200"/>
</p>

*他の言語で読む: [英語](README.md), [日本語](README.ja.md)*

## VoxelammingSwiftとは？

VoxelammingSwiftは、拡張現実を通じて視覚的かつインタラクティブにプログラミングの概念を学習・教育できるようにします。Voxelammingアプリとシームレスに連携するよう設計されており、iOS 16以降を搭載したiPhoneおよびiPad、Vision Proをサポートしています。

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

| メソッド名 | 説明 | 引数 |
|---|---|---|
| `set_room_name(room_name)` | デバイスと通信するためのルーム名を設定します。 | `room_name`: ルーム名 (string) |
| `set_box_size(size)` | ボクセルのサイズを設定します (デフォルト: 1.0)。 | `size`: サイズ (float) |
| `set_build_interval(interval)` | ボクセルの設置間隔を設定します (デフォルト: 0.01秒)。 | `interval`: 間隔 (float) |
| `change_shape(shape)` | ボクセルの形状を変更します。 | `shape`: 形状 ("box", "sphere", "plane") |
| `change_material(is_metallic, roughness)` | ボクセルの材質を変更します。 | `is_metallic`: 金属にするかどうか (boolean), `roughness`: 粗さ (float) |
| `create_box(x, y, z, r, g, b, alpha)` | ボクセルを設置します。 | `x`, `y`, `z`: 位置 (float), `r`, `g`, `b`, `alpha`: 色 (float, 0-1) |
| `create_box(x, y, z, texture)` | テクスチャ付きのボクセルを設置します。 | `x`, `y`, `z`: 位置 (float), `texture`: テクスチャ名 (string) |
| `remove_box(x, y, z)` | ボクセルを削除します。 | `x`, `y`, `z`: 位置 (float) |
| `write_sentence(sentence, x, y, z, r, g, b, alpha, font_size, is_fixed_width)` | 文字列をボクセルで描画します。 | `sentence`: 文字列 (string), `x`, `y`, `z`: 位置 (float), `r`, `g`, `b`, `alpha`: 色 (float, 0-1), `font_size`: フォントサイズ (8, 12, 16, 24), is_fixed_width: 固定長にするか (0 or 1) |
| `set_light(x, y, z, r, g, b, alpha, intensity, interval, light_type)` | ライトを設置します。 | `x`, `y`, `z`: 位置 (float), `r`, `g`, `b`, `alpha`: 色 (float, 0-1), `intensity`: 強さ (float), `interval`: 点滅間隔 (float), `light_type`: ライトの種類 ("point", "spot", "directional") |
| `set_command(command)` | コマンドを実行します。 | `command`: コマンド ("axis", "japaneseCastle", "float", "liteRender") |
| `draw_line(x1, y1, z1, x2, y2, z2, r, g, b, alpha)` | 2点間に線を描画します。 | `x1`, `y1`, `z1`: 始点 (float), `x2`, `y2`, `z2`: 終点 (float), `r`, `g`, `b`, `alpha`: 色 (float, 0-1) |
| `create_model(model_name, x, y, z, pitch, yaw, roll, scale, entity_name)` | 内蔵のモデル（USDZ）を作成します。 | `model_name`: モデル名 (string), `x`, `y`, `z`: 移動量 (float), `pitch`, `yaw`, `roll`: 回転量 (float) ,  `scale`: スケール (float), `entity_name`: 作成したモデルにつける名前 (string)|
| `move_model(entity_name, x, y, z, pitch, yaw, roll, scale)` | 作成したモデル（USDZ）を移動します。 | `entity_name`: 作成したモデルにつける名前 (string), `x`, `y`, `z`: 移動量 (float), `pitch`, `yaw`, `roll`: 回転量 (float) ,  `scale`: スケール (float)|
| `send_data(name)` | ボクセルデータをデバイスに送信します。name引数を設定すると、ボクセルデータを履歴として保存して、再現することができます。 | |
| `clear_data()` | ボクセルデータを初期化します。 | |
| `transform(x, y, z, pitch, yaw, roll)` | ボクセルの座標系を移動・回転します。 | `x`, `y`, `z`: 移動量 (float), `pitch`, `yaw`, `roll`: 回転量 (float) |
| `animate(x, y, z, pitch, yaw, roll, scale, interval)` | ボクセルをアニメーションさせます。 | `x`, `y`, `z`: 移動量 (float), `pitch`, `yaw`, `roll`: 回転量 (float), `scale`: スケール (float), `interval`: 間隔 (float) |
| `animate_global(x, y, z, pitch, yaw, roll, scale, interval)` | 全てのボクセルをアニメーションさせます。 | `x`, `y`, `z`: 移動量 (float), `pitch`, `yaw`, `roll`: 回転量 (float), `scale`: スケール (float), `interval`: 間隔 (float) |
| `push_matrix()` | 現在の座標系をスタックに保存します。 | |
| `pop_matrix()` | スタックから座標系を復元します。 | |
| `frame_in()` | フレームの記録を開始します。 | |
| `frame_out()` | フレームの記録を終了します。 | |
| `set_frame_fps(fps)` | フレームレートを設定します (デフォルト: 2)。 | `fps`: フレームレート (int) |
| `set_frame_repeats(repeats)` | フレームの再生回数を設定します (デフォルト: 10)。 | `repeats`: 再生回数 (int) |
| ゲームメソッド名                                                                               | 説明 | 引数                                                                                                                                                                |
| `set_game_screen_size(width, height, angle=90, r=1, g=1, b=0, alpha=0.5)`           | ゲーム画面を設定します。 | `width`, `height`: 画面サイズ (float), `angle`: 角度 (float) , `r`, `g`, `b`, `alpha`: 色 (float, 0-1)                                                                    |
| `set_game_score(score, x=0, y=0)`                                                             | ゲームスコアを設定します。 | `score`: ゲームのスコア(int), `x`, `y`: 位置 (float)                                                                                                                                             |
| `send_game_over()`                                                                  | ゲームオーバーを設定します。 |                                                                                                                                                                   |
| `send_game_clear()`                                                                  | ゲームクリアを設定します。 |                                                                                                                                                                   |
| `create_sprite(sprite_name, color_list, x, y, direction=90, scale=1, visible=True)` | スプライトを作成します。 | `sprite_name`: スプライトの名前 (string), `color_list`: ドットの色データ (string), `x`, `y`: 位置 (float), `direction`: 角度 (float), `sclae`: スケール (float), `visiable`: 表示 (boolean) |
| `move_sprite(sprite_name, x, y, direction=90, scale=1, visible=True)`               | スプライトを移動します。 | `sprite_name`: スプライトの名前 (string), `x`, `y`: 位置 (float), `direction`: 角度 (float), `sclae`: スケール (float), `visiable`: 表示 (boolean)                                  |
| `move_sprite_clone(sprite_name, x, y, direction=90, scale=1,)`               | スプライトのクローンを移動します。複数回の実行が可能で、複数のスプライトを作成するときに使います。 | `sprite_name`: スプライトの名前 (string), `x`, `y`: 位置 (float), `direction`: 角度 (float), `sclae`: スケール (float)                                  |
| `display_dot(sprite_name, x, y, direction=90, scale=1)`               | 弾やパティクルなど複数のドットを配置する時に使用します。 | `sprite_name`: スプライトの名前 (string), `x`, `y`: 位置 (float), `direction`: 角度 (float), `sclae`: スケール (float)                                  |
| `display_text(sprite_name, x, y, direction=90, scale=1, is_vertical=True, align='')`               | ゲーム画面にテキストを表示します。 | `sprite_name`: スプライトの名前 (string), `x`, `y`: 位置 (float), `direction`: 角度 (float), `sclae`: スケール (float), `is_vertical`: 縦書き表示 (boolean), `align`: 文字寄せ（'Top', 'Bottom', 'Right', 'Left' の組み合わせ）                                  |

## ライセンス

このプロジェクトは [MITライセンス](LICENSE) の下でライセンスされています。

## お問い合わせ

ご質問やサポートが必要な場合は、[GitHubリポジトリ](https://github.com/creativival/VoxelammingSwift/issues)でイシューをオープンしてください。

---

