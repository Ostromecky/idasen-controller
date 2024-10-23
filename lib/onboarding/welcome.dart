import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onButtonPressed;

  const WelcomeScreen({super.key, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;


    return Stack(
      children: [
        CustomPaint(
          painter: ArcPaint(
              primary: theme.colorScheme.primary,
              secondary: theme.colorScheme.secondary),
          child: SizedBox(
            height: size.height / 1.35,
            width: size.width,
          ),
        ),
        Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Lottie.asset('assets/onboarding.json', width: 500)),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 280,
            child: Column(
              children: [
                Text('IDÅSEN Controller', style: theme.textTheme.displaySmall),
                const SizedBox(height: 16),
                Text('Work comfortably with your IDÅSEN desk',
                    style: theme.textTheme.bodyMedium),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    textStyle: theme.textTheme.bodyLarge,
                  ),
                  child: const Text('Get Started'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ArcPaint extends CustomPainter {
  final Color primary;
  final Color secondary;

  ArcPaint({required this.primary, required this.secondary});

  @override
  void paint(Canvas canvas, Size size) {
    Path orangeArc = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - 175)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, size.height - 175)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(orangeArc, Paint()..color = secondary);

    Path whiteArc = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(0.0, size.height - 180)
      ..quadraticBezierTo(
          size.width / 2, size.height - 60, size.width, size.height - 180)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(
      whiteArc,
      Paint()..color = primary,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
