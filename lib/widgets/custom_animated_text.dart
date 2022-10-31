import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAnimatedText extends StatelessWidget {
  const CustomAnimatedText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      child: AnimatedTextKit(
        onNext: (p0, p1){},
        animatedTexts: [
          ColorizeAnimatedText('ATTENDANCE',
              speed: const Duration(milliseconds: 400),
              textStyle: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                fontFamily:
                GoogleFonts.poppins().fontFamily,
              ),
              colors: [Colors.white, Colors.orangeAccent]),
          ColorizeAnimatedText('GEO TRACKING',
              speed: const Duration(milliseconds: 400),
              textStyle: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                fontFamily:
                GoogleFonts.poppins().fontFamily,
              ),
              colors: [Colors.white, Colors.orangeAccent]),
          ColorizeAnimatedText('CLASSROOM',
              speed: const Duration(milliseconds: 400),
              textStyle: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                fontFamily:
                GoogleFonts.poppins().fontFamily,
              ),
              colors: [Colors.white, Colors.orangeAccent]),
        ],
        isRepeatingAnimation: true,
        repeatForever: true,
      ),
    );
  }
}

