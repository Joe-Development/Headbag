# FiveM Headbag Script

a pretty cool headbag script i made with Sounds if you like it star the repo 

---

Support Discord -> https://discord.gg/3wdq48EY

---

## Features
- **Easy to Use**: Simple Command usage.
- **Customizable**: Modify the configuration to suit your server's needs.
- **Optimized**: **SUPER** Minimal performance impact on your server.
- **Immersive Gameplay**: Enhances roleplay scenarios like kidnappings or hostage situations.

---

## Installation
1. **Download the Script**:
   - Clone the repository or download the ZIP file.

2. **Extract and Install**:
   - Place the folder into your `resources` directory, make sure to rename the resource to `headbag`

3. **Add to Server Config**:
   - Add the following line to your `server.cfg`:
     ```plaintext
     ensure Headbag
     ```

4. **Start the Resource**
   - you can use `txAdmin` or restart your server to start it

---

## Commands
- `/headbag` - Places/removes a headbag on the closest player

---

## Development Exports ( Client Side )

```lua
exports['headbag']:ForceHeadbag('on') -- Enables the headbag effect
exports['headbag']:ForceHeadbag('off') -- Disables the headbag effect

-- To detect if its on or off

exports['headbag']:GetHeadbagStatus() -- returns true or false
```

## Screenshot(s)
![Image](https://github.com/user-attachments/assets/f43079f6-5676-4e1f-b583-97ba5d2b9242)
