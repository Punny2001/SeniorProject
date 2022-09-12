import 'package:flutter/material.dart';

class PaddingDecorate extends StatelessWidget {
  final double size;

  PaddingDecorate(this.size);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(size),
    );
  }
}
