import 'package:flutter/material.dart';

class CustomOpenRightwardsPageTransitionsBuilder
    extends PageTransitionsBuilder {
  const CustomOpenRightwardsPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // When navigating forward, slide the new page in from the right
    if (animation.status == AnimationStatus.forward) {
      /* return SlideTransition(
        position: offsetAnimation,
        child: child,
      );*/

      /// fade animation
      /*  return FadeTransition(
        opacity: animation,
        child: child,
      );*/

      /* return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
         // begin: const Offset(-1.0, 0.0),
         // end: Offset.zero,
        ).animate(animation),
        child: child,
      );*/
      var begin = const Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(position: animation.drive(tween), child: child);
    }
    // When navigating backward, slide the new page out to the left
    else if (animation.status == AnimationStatus.reverse) {
      var begin = const Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
      /*return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
         // begin: const Offset(-1.0, 0.0),
          end: Offset.zero,

        ).animate(animation),
        child: child,
      );*/
    }
    // If the animation status is completed, return the child directly
    else {
      return child;
    }
  }
}

class CustomOpenUpwardsPageTransitionsBuilder extends PageTransitionsBuilder {
  /// Constructs a page transition animation that matches the transition used on
  /// Android P.
  const CustomOpenUpwardsPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _CustomOpenUpwardsPageTransitionsBuilder(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
}

class _CustomOpenUpwardsPageTransitionsBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const _CustomOpenUpwardsPageTransitionsBuilder({
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  static const Curve downCurve = Cubic(0.75, 1.0, 0.04, 1.0);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final CurvedAnimation upPageCurvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
          reverseCurve: downCurve,
        );

        final CurvedAnimation downCurvedAnimation = CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.fastOutSlowIn,
          reverseCurve: downCurve,
        );

        final Animation upPageTranslationAnimation = Tween<Offset>(
          begin: const Offset(0.0, 0.1),
          end: Offset.zero,
        ).animate(upPageCurvedAnimation);

        final Animation downPageTranslationAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.0, -0.025),
        ).animate(downCurvedAnimation);

        return AnimatedBuilder(
          animation: animation,
          child: FractionalTranslation(
            translation: upPageTranslationAnimation.value,
            child: child,
          ),
          builder: (BuildContext context, Widget? child) {
            return AnimatedBuilder(
              animation: secondaryAnimation,
              child: FractionalTranslation(
                translation: upPageTranslationAnimation.value,
                child: child,
              ),
              builder: (BuildContext context, Widget? child) {
                return FractionalTranslation(
                  translation: downPageTranslationAnimation.value,
                  child: child,
                );
              },
            );
          },
        );
      },
    );
  }
}
