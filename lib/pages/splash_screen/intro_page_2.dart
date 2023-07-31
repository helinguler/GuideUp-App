import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/constant/color_constants.dart';

class IntroPage2 extends StatefulWidget {
  @override
  _IntroPage2State createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (BuildContext context, Widget? child) {
                return Align(
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: const Offset(0, -50),
                    child: Transform.scale(
                      scale: _animation.value,
                      child: Image.asset(
                        'assets/img/2.png',
                        height: 300,
                        width: 300,
                      ),
                    ),
                  ),
                );
              },
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 1),
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Center(
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: Text('MENTOR MU BULMAK İSTİYORSUN ?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          color: ColorConstants.textwhite,
                          fontSize: 21,
                          height: -2,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 0),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: Text(
                    'Alanında uzman mentorlerimiz ile görüş, kendinin en iyisi ol.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        color: ColorConstants.textwhite,
                        height: 0,
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                      ),
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
