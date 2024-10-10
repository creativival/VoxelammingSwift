//
//  README.md
//  VoxelammingSwift
//
//  Created by user_name on 2024/10/10.
//

# VoxelammingSwift

VoxelammingSwift is a Swift package that enables developers to create voxel-based 3D AR experiences programmatically. By communicating with the Voxelamming AR app via WebSocket, you can place and manipulate voxels (3D cubes) in an augmented reality environment using Swift code.

<p align="center">
  <img src="https://creativival.github.io/voxelamming/image/voxelamming_icon.png" alt="Voxelamming Logo" width="200"/>
</p>

## What is VoxelammingSwift?

VoxelammingSwift allows you to learn and teach programming concepts visually and interactively through augmented reality. It is designed to work seamlessly with the Voxelamming app, supporting iPhones and iPads with iOS 16 or later.

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

Below is a list of key methods available in VoxelammingSwift:

- **Initialization:**
  - `init(roomName: String)`: Initializes the connection with the specified room name.

- **Voxel Manipulation:**
  - `setBoxSize(_ boxSize: Double)`: Sets the size of the voxels (default is `1.0`).
  - `createBox(_ x: Double, _ y: Double, _ z: Double, r: Double = 1, g: Double = 1, b: Double = 1, alpha: Double = 1, texture: String = "")`: Places a voxel at the specified coordinates with the given color or texture.
  - `removeBox(_ x: Double, _ y: Double, _ z: Double)`: Removes the voxel at the specified coordinates.
  - `drawLine(_ x1: Double, _ y1: Double, _ z1: Double, _ x2: Double, _ y2: Double, _ z2: Double, r: Double = 1, g: Double = 1, b: Double = 1, alpha: Double = 1)`: Draws a line between two points using voxels.

- **Transformations and Animations:**
  - `transform(_ x: Double, _ y: Double, _ z: Double, pitch: Double = 0, yaw: Double = 0, roll: Double = 0)`: Translates and rotates the coordinate system.
  - `animate(_ x: Double, _ y: Double, _ z: Double, pitch: Double = 0, yaw: Double = 0, roll: Double = 0, scale: Double = 1, interval: Double = 10)`: Animates voxels with the specified parameters.
  - `animateGlobal(_ x: Double, _ y: Double, _ z: Double, pitch: Double = 0, yaw: Double = 0, roll: Double = 0, scale: Double = 1, interval: Double = 10)`: Applies animation globally to all voxels.

- **Advanced Features:**
  - `pushMatrix()`: Saves the current transformation matrix.
  - `popMatrix()`: Restores the last saved transformation matrix.
  - `setLight(...)`: Adds lighting effects to the scene.
  - `createModel(...)`: Places a built-in 3D model into the AR environment.
  - `moveModel(...)`: Moves an existing model within the AR scene.

- **Communication:**
  - `sendData(name: String = "")`: Sends the current voxel data to the Voxelamming app. Optionally, provide a `name` to save the state.
  - `clearData()`: Clears all voxel data from the current session.

For detailed usage of each method, please refer to the [documentation](#).

## License

This project is licensed under the [MIT License](LICENSE).

## Contact

For questions or support, please open an issue on the [GitHub repository](https://github.com/creativival/VoxelammingSwift/issues).
