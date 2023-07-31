import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/constant/color_constants.dart';

class IntroPage5 extends StatefulWidget {
  @override
  _IntroPage5State createState() => _IntroPage5State();
}

class _IntroPage5State extends State<IntroPage5>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5,
            1.0), // Metnin gecikmeli olarak görünmesi için animasyonun ikinci yarısını kullanıyoruz
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstants.darkBack,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: Image.asset(
                    'assets/logo/guideUpLogoWithBackground.png',
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            FadeTransition(
              opacity: _opacityAnimation,
              child: Text(
                'GuideUp Hoşgeldiniz',
                style: GoogleFonts.nunito(
                  textStyle: TextStyle(
                    color: ColorConstants.textwhite,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
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
