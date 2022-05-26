import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LanguageSign extends StatefulWidget {
  @override
  State<LanguageSign> createState() => _LanguageSignState();
}

class _LanguageSignState extends State<LanguageSign> {
  bool _isEN;
  @override
  Widget build(BuildContext context) {
    if (context.locale.languageCode == 'en') {
      _isEN = true;
    } else {
      _isEN = false;
    }
    return IconButton(
      icon: _isEN
          ? SvgPicture.asset(
              'icons/flags/svg/th.svg',
              package: 'country_icons',
            )
          : SvgPicture.asset(
              'icons/flags/svg/us.svg',
              package: 'country_icons',
            ),
      onPressed: () {
        setState(
          () {
            if (context.locale.languageCode == 'en') {
              context.setLocale(const Locale('th', 'TH'));
              _isEN = false;
            } else if (context.locale.languageCode == 'th') {
              context.setLocale(const Locale('en', 'US'));
              _isEN = true;
            }
          },
        );
      },
    );
  }
}
