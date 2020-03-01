import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CatAnimation(),
      ),
    );
  }
}

class CatAnimation extends StatefulWidget {
  @override
  _CatAnimationState createState() => _CatAnimationState();
}

class _CatAnimationState extends State<CatAnimation>
    with TickerProviderStateMixin {
  Animation animation;
  AnimationController controller;
  Animation flapAnimation;
  AnimationController flapController;
  AnimationController flapControllerRight;
  Animation flapAnimationRight;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween(begin: 0.0, end: 70.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

    flapController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    flapAnimation = Tween(begin: pi * 0.25, end: pi * 0.35).animate(
      CurvedAnimation(parent: flapController, curve: Curves.easeOut),
    );

    flapControllerRight =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    flapAnimationRight = Tween(begin: -(pi * 0.25), end: -(pi * 0.35)).animate(
      CurvedAnimation(parent: flapControllerRight, curve: Curves.easeOut),
    );

    flapAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        flapController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        flapController.forward();
      }
    });
    flapController.forward();

    flapAnimationRight.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        flapControllerRight.reverse();
      } else if (status == AnimationStatus.dismissed) {
        flapControllerRight.forward();
      }
    });

    flapControllerRight.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: <Widget>[
          CatAnimationBuilder(animation: animation),
          GestureDetector(
            onTap: () {
              if (animation.status == AnimationStatus.dismissed) {
                controller.forward();
                flapControllerRight.stop();
                flapController.stop();
              } else if (animation.status == AnimationStatus.completed) {
                controller.reverse();
                flapControllerRight.forward();
                flapController.forward();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.tealAccent, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              height: 200,
              width: 200,
            ),
          ),
          Flaps(
            flapAnimationlocal: flapAnimation,
            left: 8,
            inputAlignment: Alignment.topLeft,
          ),
          Flaps(
            flapAnimationlocal: flapAnimationRight,
            right: 8,
            inputAlignment: Alignment.topRight,
          ),
        ],
      ),
    );
  }
}

class CatAnimationBuilder extends StatelessWidget {
  const CatAnimationBuilder({
    @required this.animation,
  });

  final Animation animation;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 80,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Container(
            child: child,
            margin: EdgeInsets.only(bottom: animation.value),
          );
        },
        child: Cat(),
      ),
    );
  }
}

class Cat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/dog.png',
      height: 150,
    );
  }
}

class Flaps extends StatelessWidget {
  Flaps(
      {@required this.flapAnimationlocal,
      this.inputAlignment,
      this.left,
      this.right});
  final Animation flapAnimationlocal;
  final double left;
  final double right;
  final AlignmentGeometry inputAlignment;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: 0,
      child: AnimatedBuilder(
        animation: flapAnimationlocal,
        builder: (context, child) {
          return Transform.rotate(
            alignment: inputAlignment,
            angle: flapAnimationlocal.value,
            child: child,
          );
        },
        child: Container(
          height: 80,
          width: 8,
          color: Colors.tealAccent,
        ),
      ),
    );
  }
}
