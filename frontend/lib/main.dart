import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animated Heart',
      home: HomeScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 242, 17, 96),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _particleController;
  List<HeartParticle> particles = [];
  final Random random = Random();
  bool showMessage = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: Duration(days: 365),
    )..repeat();

    _particleController.addListener(() {
      setState(() {
        for (var particle in particles) {
          particle.update();
        }
        particles.removeWhere((p) => p.isDead);

       
        if (particles.isEmpty) {
          showMessage = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _spawnHearts() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    setState(() {
      showMessage = true;
    });

    for (int i = 0; i < 20; i++) {
      particles.add(HeartParticle(
        x: random.nextDouble() * screenWidth,
        y: screenHeight - 50,
        vx: random.nextDouble() * 4 - 2,
        vy: -3 - random.nextDouble() * 4,
        size: 20 + random.nextDouble() * 30,
        rotation: random.nextDouble() * 0.5 - 0.25,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Stack(
          children: [
            // Main beating heart in center
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      print("Heart Pressed");
                      _spawnHearts();
                    },
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return CustomPaint(
                          size: Size(300, 300),
                          painter: MyPainter(scale: _controller.value),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Click this heart to see magic ✨",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            // "Happy Coding!" message
            if (showMessage)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 200),
                  child: AnimatedOpacity(
                    opacity: showMessage ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Text(
                      "Happy Coding!",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.red,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // Flying hearts particles
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: HeartParticlesPainter(particles),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Heart Particle Model
class HeartParticle {
  double x;
  double y;
  double vx;
  double vy;
  double opacity;
  double size;
  double rotation;

  HeartParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    this.opacity = 1.0,
    this.size = 30.0,
    this.rotation = 0.0,
  });

  void update() {
    x += vx;
    y += vy;
    opacity -= 0.005; 
  }

  bool get isDead => opacity <= 0;
}

// Heart Particles Painter
class HeartParticlesPainter extends CustomPainter {
  final List<HeartParticle> particles;

  HeartParticlesPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      canvas.save();
      canvas.translate(particle.x, particle.y);
      canvas.rotate(particle.rotation);

      final paint = Paint()
        ..color = Colors.red.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      //  small heart using the same path logic
      final heartSize = particle.size;
      Path path = Path();

      // Scaled down 
      path.moveTo(heartSize * 0.5, heartSize * 0.90);

      path.cubicTo(
        heartSize * 0.01,
        heartSize * 0.50,
        heartSize * 0.40,
        heartSize * 0.3,
        heartSize * 0.50,
        heartSize * 0.5,
      );

      path.cubicTo(
        heartSize * 0.74,
        heartSize * 0.27,
        heartSize * 1,
        heartSize * 0.67,
        heartSize * 0.5,
        heartSize * 0.90,
      );

      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MyPainter extends CustomPainter {
  MyPainter({this.scale = 1.0});
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(0.9 + (scale * 0.2));
    canvas.translate(-size.width / 2, -size.height / 2);
    final solidPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 1 + (scale * 20));

    Path path = Path();

    // Starting Point: 0.5 = horizontal CENTER, 0.90 = near BOTTOM (sharp tip)
    path.moveTo(size.width * 0.5, size.height * 0.90);

    // LEFT CURVE
    path.cubicTo(
      size.width * 0.01, // 0.01, 0.50 = Pulls left side OUTWARD (left bulge)
      size.height * 0.50,
      size.width * 0.40, // 0.40, 0.30 = Creates ROUNDNESS of left bump at top
      size.height * 0.3,
      size.width * 0.50, // Ends at 0.50, 0.5 = CENTER-TOP area
      size.height * 0.5,
    );

    // RIGHT CURVE
    path.cubicTo(
      size.width * 0.74, // 0.74, 0.27 = Creates ROUNDNESS of right bump at top
      size.height * 0.27,
      size.width * 1, // 1.0, 0.67 = Pulls right side OUTWARD (right bulge)
      size.height * 0.67,
      size.width * 0.5, // Ends at 0.50, 0.90 = BOTTOM-CENTER tip (closes shape)
      size.height * 0.90,
    );

    // Draw glow first (behind)
    canvas.drawPath(path, paint);

    // Draw solid heart on top
    canvas.drawPath(path, solidPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

        // 2●         ●4
        //  |\       /|
        //  | \  3● / |
        //  |  \  | /  |
        //  |   \ |/   |
        //  |    \|    |
        //  |     |    |
        //   \    |   /
        //    \   |  /
        //     \  | /
        //      \ |/
        //       ●1

// Point 1: Bottom tip (start)
// Point 2: Left bump peak
// Point 3: Center dip
// Point 4: Right bump peak
// Point 5: (Back to Point 1)