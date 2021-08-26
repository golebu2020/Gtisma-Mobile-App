import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShaderMaskIcon extends StatelessWidget {
  final Widget child;
  ShaderMaskIcon(this.child);
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds)=>
        RadialGradient(
          center: Alignment.topLeft,
          radius: 1.0,
          colors: [
            // Colors.white,
            // Colors.white,
            Color.fromRGBO(120, 78, 125, 0.6),
            Colors.white,
            //Color.fromRGBO(120, 78, 125, 0.6),
          ],
          tileMode: TileMode.mirror,
        ).createShader(bounds),
      child: child,
    );
  }
}
