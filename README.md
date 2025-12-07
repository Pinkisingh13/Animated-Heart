# Animated Heart

⭐ **If you like this project, give it a star!** ⭐

An interactive Flutter web app featuring a beating heart animation with particle effects, built entirely with CustomPainter.

**Live Demo:** [code2heart.netlify.app](https://code2heart.netlify.app)

## Demo

https://github.com/user-attachments/assets/your-video-id-here.mp4

> **Note:** Replace the URL above with your actual video. To add a video:
> 1. Go to any GitHub issue or PR
> 2. Drag and drop your video file
> 3. Copy the generated URL and replace it above
> 4. Delete this note

## Features

- **Beating Heart Animation** - Pulsing heart with glow effect using CustomPainter
- **Interactive Particles** - Click the heart to spawn flying heart particles
- **Smooth Animations** - Physics-based particle movement with fade-out effects
- **Responsive Design** - Works across all screen sizes

## Tech Stack

- **Flutter Web** - Cross-platform UI framework
- **CustomPainter** - For hand-drawn heart paths and particle rendering
- **Canvas API** - Direct 2D graphics drawing
- **AnimationController** - Manages beating and particle animations

## The Challenge

This was my first time learning CustomPainter. Drawing the heart shape using Bézier curves and canvas paths took **5-6 hours** of trial and error. Getting the cubic curves right to create the two rounded bumps at the top and the sharp point at the bottom was particularly challenging—each control point needed precise positioning to achieve the natural heart shape.

The particle system added another layer of complexity, requiring:
- Individual particle tracking with position, velocity, and opacity
- Continuous canvas repainting for smooth animation
- Rotation and fade-out effects synchronized with movement

## Installation

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

## Build for Web

```bash
cd frontend
flutter build web
```

The output will be in `build/web/` directory.

## Project Structure

```
frontend/
├── lib/
│   └── main.dart          # Main app + CustomPainter implementations
├── pubspec.yaml           # Dependencies
└── web/                   # Web assets
```

## How It Works

1. **MyPainter** - Draws the main beating heart using `Path.cubicTo()` for Bézier curves
2. **HeartParticlesPainter** - Renders all flying particles on each frame
3. **AnimationController** - Drives the beating effect and particle updates
4. **Physics Simulation** - Particles move with velocity vectors and fade over time
