import 'package:flutter/material.dart';

class GlowingStars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 140,
      width: width,
      child: Stack(
        children: <Widget>[
          //star 0
          Positioned(
            top: 10,
            right: 5,
            child: Star(size: 4.5, radius: 6.0, start: 0.8, end: 0.1, asset: 'star'),
          ),
          //star 1
          Positioned(
            top: 50,
            right: 10,
            child: Star(size: 7.5, radius: 4.0, start: 0.2, end: 0.9, asset: 'star'),
          ),
          //star 2
          Positioned(
            top: 0,
            right: 88,
            child: Star(size: 6.5, radius: 6.0, start: 0.9, end: 0.3, asset: 'star'),
          ),
          //star 3
          Positioned(
            top: 3,
            left: 4,
            child: Star(size: 5.5, radius: 4.0, start: 0.1, end: 0.9, asset: 'star'),
          ),
          //star 4
          Positioned(
            top: 8,
            left: 65,
            child: Star(size: 7.5, radius: 4.0, start: 0.9, end: 0.2, asset: 'star'),
          ),
          //circle star 0
          Positioned(
            top: 42,
            right: 50,
            child: Star(size: 2.0, radius: 1.5, start: 0.9, end: 0.1, asset: 'circleStar'),
          ),
          //circle star 1
          Positioned(
            top: 50,
            right: 100,
            child: Star(size: 3.0, radius: 1.5, start: 0.9, end: 0.1, asset: 'circleStar'),
          ),
          //circle star 2
          Positioned(
            top: 10,
            right: 45,
            child: Star(size: 4.6, radius: 1.5, start: 0.2, end: 0.8, asset: 'circleStar'),
          ),
          //circle star 3
          Positioned(
            top: 30,
            right: 75,
            child: Star(size: 3.0, radius: 1.5, start: 0.1, end: 0.8, asset: 'circleStar'),
          ),
          //circle star 4
          Positioned(
            top: 0,
            left: 95,
            child: Star(size: 2.6, radius: 1.5, start: 0.2, end: 0.7, asset: 'circleStar'),
          ),
          //circle star 5
          Positioned(
            top: 18,
            left: 38,
            child: Star(size: 2.0, radius: 1.5, start: 0.8, end: 0.1, asset: 'circleStar'),
          ),
          //circle star 6
          Positioned(
            top: 40,
            left: 15,
            child: Star(size: 4.6, radius: 1.5, start: 0.8, end: 0.1, asset: 'circleStar'),
          ),
          //circle star 8
          Positioned(
            top: 50,
            left: 65,
            child: Star(size: 3.0, radius: 1.5, start: 0.1, end: 0.9, asset: 'circleStar'),
          ),
          //circle star 9
          Positioned(
            top: 40,
            left: 110,
            child: Star(size: 3.0, radius: 1.5, start: 0.9, end: 0.2, asset: 'circleStar'),
          ),
        ],
      ),
    );
  }
}

class Star extends StatefulWidget {
  Star({
    Key key,
    this.size,
    this.asset,
    this.radius,
    this.start,
    this.end,
  }) : super(key: key);
  final double size;
  final String asset;
  final double radius;
  final double start;
  final double end;
  @override
  _StarState createState() => _StarState();
}

class _StarState extends State<Star> with SingleTickerProviderStateMixin {
  Animation<double> animationStar;
  AnimationController controller;
  ValueNotifier<Animation<double>> opacity ;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(seconds: 2), reverseDuration: Duration(seconds: 2))
      ..forward()
      ..repeat(reverse: true);
    animationStar = Tween<double>(begin: widget.start, end: widget.end).animate(controller)
      ..addListener(() {
        opacity.value = animationStar;
      });
    opacity = ValueNotifier<Animation<double>>(animationStar);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Animation<double>>(
      valueListenable: opacity,
      builder: (BuildContext context, Animation<double> value, Widget child) => FadeTransition(opacity: value, child: child),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.white30,
              blurRadius: widget.radius,
              spreadRadius: 3.2,
            ),
          ],
        ),
        child: Image.asset('assets/${widget.asset}.png', width: widget.size),
      ),
    );
  }
}
