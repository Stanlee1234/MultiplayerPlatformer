# Multiplayer 2D Platformer Prototype

This project is built in **Godot 4** and features a fully synchronized client-server architecture, smooth state-machine character controllers, and borrowed pixel art animations.
---

## 🛠️ Prerequisites
To play or test this game, you will need:
* **Godot Engine:** Version 4.0 or higher (Forward+ renderer recommended).
* **The Source Code:** Clone or download this repository to your machine.

---

##  How to Play & Test

1. Open the project in Godot 4.
2. Go to **Debug > Run Multiple Instances** at the top of the editor and set it to **2 instances**.
3. Press **F5** (or the Play button) to run the game. Two windows will pop up.
4. On Window 1, click **Host**.
5. On Window 2, leave the IP blank (or type `127.0.0.1`) and click **Join**.
---

##  Controls
The game currently supports keyboard controls. 

| Action | Input | Description |
| :--- | :--- | :--- |
| **Move Left/Right** | `Left / Right Arrows` | Move the character. |
| **Jump** | `Up Arrow` | Standard jump. |
| **Wall Jump** | `Up Arrow` | Press while sliding down a wall to leap away. |
| **Crouch** | `Down Arrow` | Hold while standing still to crouch. |
| **Crouch Walk** | `Down + Left/Right` | Sneak around at half speed. |
| **Roll** | `Down` (While running) | Quick burst of speed that locks movement until finished. |

---

*Built with [Godot Engine](https://godotengine.org/).*
