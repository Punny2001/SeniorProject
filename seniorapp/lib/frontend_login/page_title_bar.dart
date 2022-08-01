import 'package:flutter/material.dart';

class PageTitleBar extends StatelessWidget {
  const PageTitleBar({ Key key, this.imgUrl }) : super(key: key);
  final String imgUrl;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 300.0),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 2,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top:16.0),
          child: Image.asset(
            imgUrl,
            alignment: Alignment.topCenter,
            scale: 8.75,
          ),
        ),
      ),
    );
  }
}