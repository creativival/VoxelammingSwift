# VoxelammingSwift

VoxelammingSwift is a Swift package that enables developers to create voxel-based 3D AR experiences programmatically. By communicating with the Voxelamming AR app via WebSocket, you can place and manipulate voxels (3D cubes) in an augmented reality environment using Swift code.

<p align="center">
  <img src="https://creativival.github.io/voxelamming/image/voxelamming_icon.png" alt="Voxelamming Logo" width="200"/>
</p>

*Read this in other languages: [English](README.md), [日本語](README.ja.md)*

## What is VoxelammingSwift?

VoxelammingSwift allows you to learn and teach programming concepts visually and interactively through augmented reality. It is designed to work seamlessly with the Voxelamming app, supporting iPhones / iPads with iOS 16 or later and Vision Pro.

**Target Users:**

- **Programming Learners:** Understand programming basics with immediate visual feedback in AR.
- **Generative Artists:** Create intricate 3D artworks using code and AR technology.

## Features

- **Intuitive AR Integration:** Place voxels in the real world to enhance spatial understanding.
- **Easy-to-Use API:** Simple methods to create, transform, and animate voxels.
- **Real-Time Communication:** Uses WebSocket for instant updates between your code and the AR app.
- **Cross-Platform Development:** Write code on macOS to interact with iOS devices.

## Installation

To add VoxelammingSwift to your Xcode project:

1. **Swift Package Manager (Recommended):**

   - Open your Xcode project.
   - Navigate to **File > Add Packages...**
   - Enter the repository URL:
     ```
     https://github.com/creativival/VoxelammingSwift.git
     ```
   - Choose the version and add the package to your project.

2. **Manual Installation:**

   - Clone the repository.
   - Drag and drop the `VoxelammingSwift` folder into your Xcode project.

## Usage

### 1. Prepare Your Device

- **Download the Voxelamming app:**
  - [App Store Link](https://apps.apple.com/jp/app/ボクセラミング/id6451427658?itsct=apps_box_link&itscg=30200)
- **Set the Plane Anchor:**
  - Launch the app and follow the on-screen instructions to place an anchor in the real world.
- **Note the Room Name:**
  - The room name displayed in the app is required for establishing a connection.

### 2. Write Your Swift Code

Import the VoxelammingSwift package and create an instance using the room name.

```swift
import VoxelammingSwift

@available(iOS 15.0, macOS 12.0, *)
func exampleUsage() async throws {
    let voxelamming = Voxelamming(roomName: "your_room_name")
    voxelamming.setBoxSize(2.0) // Set voxel size to double
    voxelamming.createBox(10, 5, -2, r: 1, g: 0, b: 0) // Place a red voxel
    try await voxelamming.sendData(name: "MyFirstVoxel")
}

### 3. Run Your Code

- Ensure your Mac and iOS device are on the same network.
- Run your Swift code to see the voxels appear in the AR environment.

## Methods Description

| Method name | Description | Arguments |
|---|---|---|
| `set_room_name(room_name)` | Sets the room name for communicating with the device. | `room_name`: Room name (string) |
| `set_box_size(size)` | Sets the size of the voxel (default: 1.0). | `size`: Size (float) |
| `set_build_interval(interval)` | Sets the placement interval of the voxels (default: 0.01 seconds). | `interval`: Interval (float) |
| `change_shape(shape)` | Changes the shape of the voxel. | `shape`: Shape ("box", "sphere", "plane") |
| `change_material(is_metallic, roughness)` | Changes the material of the voxel. | `is_metallic`: Whether to make it metallic (boolean), `roughness`: Roughness (float) |
| `create_box(x, y, z, r, g, b, alpha)` | Places a voxel. | `x`, `y`, `z`: Position (float), `r`, `g`, `b`, `alpha`: Color (float, 0-1) |
| `create_box(x, y, z, texture)` | Places a voxel with texture. | `x`, `y`, `z`: Position (float), `texture`: Texture name (string) |
| `remove_box(x, y, z)` | Removes a voxel. | `x`, `y`, `z`: Position (float) |
| `write_sentence(sentence, x, y, z, r, g, b, alpha, font_size, is_fixed_width)` | Draws a string with voxels. | `sentence`: String (string), `x`, `y`, `z`: Position (float), `r`, `g`, `b`, `alpha`: Color (float, 0-1), `font_size`: font size (8, 12, 16, 24), `is_fixed_width`: indicates if the font is monospaced (0 for false, 1 for true) |
| `set_light(x, y, z, r, g, b, alpha, intensity, interval, light_type)` | Places a light. | `x`, `y`, `z`: Position (float), `r`, `g`, `b`, `alpha`: Color (float, 0-1), `intensity`: Intensity (float), `interval`: Blinking interval (float), `light_type`: Type of light ("point", "spot", "directional") |
| `set_command(command)` | Executes a command. | `command`: Command ("axis", "japaneseCastle", "float", "liteRender") |
| `draw_line(x1, y1, z1, x2, y2, z2, r, g, b, alpha)` | Draws a line between two points. | `x1`, `y1`, `z1`: Starting point (float), `x2`, `y2`, `z2`: Ending point (float), `r`, `g`, `b`, `alpha`: Color (float, 0-1) |
| `create_model(model_name, x, y, z, pitch, yaw, roll, scale, entity_name)` | Creates a built-in model (USDZ). |  `model_name`: Name of the model (string), `x`, `y`, `z`: Translation values (float), `pitch`, `yaw`, `roll`: Rotation values (float), `scale`: Scale (float), `entity_name`: Name assigned to the created model (string) |
| `move_model(entity_name, x, y, z, pitch, yaw, roll, scale)` | Moves the created model (USDZ). |  `entity_name`: Name assigned to the created model (string), `x`, `y`, `z`: Translation values (float), `pitch`, `yaw`, `roll`: Rotation values (float), `scale`: Scale (float) |
| `send_data(name)` | Sends voxel data to the device; if the name argument is set, the voxel data can be stored and reproduced as history. | |
| `clear_data()` | Initializes voxel data. | |
| `transform(x, y, z, pitch, yaw, roll)` | Moves and rotates the coordinate system of the voxel. | `x`, `y`, `z`: Translation amount (float), `pitch`, `yaw`, `roll`: Rotation amount (float) |
| `animate(x, y, z, pitch, yaw, roll, scale, interval)` | Animates a voxel. | `x`, `y`, `z`: Translation amount (float), `pitch`, `yaw`, `roll`: Rotation amount (float), `scale`: Scale (float), `interval`: Interval (float) |
| `animate_global(x, y, z, pitch, yaw, roll, scale, interval)` | Animates all voxels. | `x`, `y`, `z`: Translation amount (float), `pitch`, `yaw`, `roll`: Rotation amount (float), `scale`: Scale (float), `interval`: Interval (float) |
| `push_matrix()` | Saves the current coordinate system to the stack. | |
| `pop_matrix()` | Restores the coordinate system from the stack. | |
| `frame_in()` | Starts recording a frame. | |
| `frame_out()` | Ends recording a frame. | |
| `set_frame_fps(fps)` | Sets the frame rate (default: 2). | `fps`: Frame rate (int) |
| `set_frame_repeats(repeats)` | Sets the number of frame repetitions (default: 10). | `repeats`: Number of repetitions (int) |
| Game Method Name                                                                              | Description | Arguments                                                                                                                                                            |
| `set_game_screen(width, height, angle=90, r=1, g=1, b=0, alpha=0.5)`                | Sets the game screen size. | `width`, `height`: screen size (float), `angle`: angle (float), `r`, `g`, `b`, `alpha`: color (float, 0-1)                                                            |
| `set_game_score(score, x=0, y=0)`                                                                  | Sets the game score. | `score`: game score (int), `x`, `y`: position (float)                                                                                                                                            |
| `send_game_over()`                                                                       | Triggers game over. |                                                                                                                                                                     |
| `send_game_clear()`                                                                  | Triggers game clear. |                                                                                                                                                                   |
| `create_sprite(sprite_name, color_list, x, y, direction=90, scale=1, visible=True)`      | Creates a sprite. | `sprite_name`: sprite name (string), `color_list`: dot color data (string), `x`, `y`: position (float), `direction`: angle (float), `scale`: scale (float), `visible`: visibility (boolean) |
| `move_sprite(sprite_name, x, y, direction=90, scale=1, visible=True)`                    | Moves a sprite. | `sprite_name`: sprite name (string), `x`, `y`: position (float), `direction`: angle (float), `scale`: scale (float), `visible`: visibility (boolean)                                  |
| `move_sprite_clone(sprite_name, x, y, direction=90, scale=1,)`               | Moves a clone of the sprite. Can be executed multiple times and is used when creating multiple sprites. | `sprite_name`: Sprite name (string), `x`, `y`: Position (float), `direction`: Direction (float), `scale`: Scale (float)                                  |
| `display_dot(sprite_name, x, y, direction=90, scale=1)`               | Used to place multiple dots, such as bullets or particles. | `sprite_name`: Sprite name (string), `x`, `y`: Position (float), `direction`: Direction (float), `scale`: Scale (float)                                  |
| `display_text(sprite_name, x, y, direction=90, scale=1, is_vertical=True, align='')`               | Displays text on the game screen. | `sprite_name`: Name of the sprite (string), `x`, `y`: Position (float), `direction`: Angle (float), `scale`: Scale (float), `is_vertical`: Vertical text display (boolean), `align`: Text alignment (combination of 'Top', 'Bottom', 'Right', 'Left')                                  |

## License

This project is licensed under the [MIT License](LICENSE).

## Contact

For questions or support, please open an issue on the [GitHub repository](https://github.com/creativival/VoxelammingSwift/issues).
