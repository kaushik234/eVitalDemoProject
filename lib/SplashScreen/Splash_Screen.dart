import 'package:demo/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../HomePage.dart';
import '../Screens/Authentication/SignIn.dart';
import '../src/utils/shared_pref.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _lineController;
  late Animation<double> _lineAnimation;

  late AnimationController _lottieController;
  late Animation<double> _lottieScaleAnimation;
  late Animation<double> _lottieOpacityAnimation;

  late AnimationController _textController;
  late Animation<double> _textOpacityAnimation;

  var Login;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    PreferenceManager.instance
        .getBooleanValue("Login")
        .then((value) => setState(() {
      Login = value;
    }));

    Future.delayed(Duration(seconds: 3), init);
  }

  void _initializeAnimations() {
    _lineController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );
    _lineAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _lineController, curve: Curves.easeInOut),
    );
    _lineController.repeat(reverse: true);

    _lottieController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _lottieScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _lottieController, curve: Curves.elasticOut),
    );
    _lottieOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _lottieController, curve: Curves.easeIn),
    );
    _lottieController.forward();

    // Text opacity animation
    _textController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textController.forward();
  }

  @override
  void dispose() {
    _lineController.dispose();
    _lottieController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> init() async {
    await Future.delayed(Duration(seconds: 1));

    if (Login!=true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );

    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );


    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kMainColor,
        body: Stack(
          children: [
            // Diagonal animated lines overlay
            AnimatedBuilder(
              animation: _lineAnimation,
              builder: (context, child) => Transform.scale(
                scale: _lineAnimation.value,
                child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width*1.2,
                      MediaQuery.of(context).size.height*1.2),
                  painter: DiagonalLinesPainter(),
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _lottieScaleAnimation,
                    child: FadeTransition(
                      opacity: _lottieOpacityAnimation,
                      child: Lottie.asset(
                        'Images/Animation/Animation - 1730012110799.json',
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width * 0.7,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _textOpacityAnimation,
                child: Center(
                  child: Text(
                    'Version 1.0.0',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiagonalLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 3;

    // Draw diagonal lines
    for (double i = -size.height; i < size.width; i += 40) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
