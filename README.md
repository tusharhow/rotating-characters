# Cosmic Rings

A Flutter animation with rotating Japanese characters and synchronization effects.

<p align="center">
  <a href="https://gitlab.com/-/project/61957092/uploads/8c6b43aa75ef6d160f61927097582197/Screen_Recording_2025-03-09_at_5.19.13_PM.mov">
    <img src="https://github.com/user-attachments/assets/fd65a3b2-c011-48c9-9690-d23feaf05dda" width="500" alt="Preview (Click to watch video)">
  </a>
  <br>
  <i>Click the image to watch the demo video</i>
</p>

## About

Four rings of Japanese characters rotate independently. When they synchronize, a special visual effect occurs.

## Features

- Rotating character rings
- Synchronization detection
- Blast effect animation
- Particle system
- Ambient glow effects

## Installation

```bash
# Clone repository
git clone https://github.com/tusharhow/rotating-characters.git

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Structure

The project is organized into modular components:

- `BlastEffect` - Explosion animation
- `GlowEffects` - Pulsing glow animations
- `CenterDot` - Central dot effect
- `RotatingRing` - Character ring rotation
- `AmbientGlow` - Background effects
- `ParticleEffect` - Particle system

## License

MIT
