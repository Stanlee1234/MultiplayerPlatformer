# 🎮 Multiplayer 2D Platformer Prototype

Welcome to the prototype of my 2D Multiplayer Platformer! This project is built in **Godot 4** and features a fully synchronized client-server architecture, smooth state-machine character controllers, and custom pixel art animations.

## ✨ Features
* **Seamless Multiplayer:** Host or join games. The Host is highlighted in gold (visible only to them), while joined players appear as ghostly blue silhouettes.
* **Fluid Movement:** Crisp pixel-perfect movement with custom gravity and jump physics.
* **Wall Mechanics:** Wall sliding, wall landing impact animations, and wall jumping.
* **Crouch & Roll:** Context-sensitive state machine. Press down while standing still to crouch, or press down while running to perform a high-speed roll.

---

## 🛠️ Prerequisites
To play or test this game, you will need:
* **Godot Engine:** Version 4.0 or higher (Forward+ renderer recommended).
* **The Source Code:** Clone or download this repository to your machine.

---

## 🚀 How to Play & Test

### Option A: Testing by yourself (Localhost)
If you just want to test the mechanics and multiplayer synchronization on your own computer:
1. Open the project in Godot 4.
2. Go to **Debug > Run Multiple Instances** at the top of the editor and set it to **2 instances**.
3. Press **F5** (or the Play button) to run the game. Two windows will pop up.
4. On Window 1, click **Host**.
5. On Window 2, leave the IP blank (or type `127.0.0.1`) and click **Join**.

### Option B: Playing with Friends (Over the Internet)
Since this game relies on direct IP connections, your friends cannot join your standard home Wi-Fi IP address without a VPN or Port Forwarding. 

The easiest way to play together is using a free virtual LAN tool like **Tailscale**:
1. You and your friends download and install [Tailscale](https://tailscale.com/).
2. Log in and connect to the same Tailscale network.
3. Tailscale will assign the Host a special VPN IP address (e.g., `100.85.x.x`).
4. **The Host** launches the game and clicks **Host**.
5. **The Joiners** launch the game, type the Host's Tailscale IP address into the text box, and click **Join**.

---

## 🕹️ Controls
The game currently supports keyboard controls. *(Ensure your Godot Input Map is configured to match these!)*

| Action | Input | Description |
| :--- | :--- | :--- |
| **Move Left/Right** | `Left / Right Arrows` | Move the character. |
| **Jump** | `Up Arrow` | Standard jump. |
| **Wall Jump** | `Up Arrow` | Press while sliding down a wall to leap away. |
| **Crouch** | `Down Arrow` | Hold while standing still to crouch. |
| **Crouch Walk** | `Down + Left/Right` | Sneak around at half speed. |
| **Roll** | `Down` (While running) | Quick burst of speed that locks movement until finished. |

---

## 📝 Known Issues & To-Do
* *Add your future plans here! (e.g., Ledge climbing, combat mechanics, level transitions).*
* *Add any current bugs your testers should ignore.*

---
*Built with [Godot Engine](https://godotengine.org/).*
