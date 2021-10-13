import 'dart:io';

import 'package:appgro/widgets/navigation_bottom_bar.dart';
import 'package:appgro/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const NavigationBottomBar(2),
        body: ScreenWrapper(
          bodyWidget: Center(
              child: Center(
            child: Image.file(File(
                '/data/user/0/com.example.appgro/app_flutter/fototomada.jpg')),
          )),
          headerWidget: const HeaderTextInfoScreen(),
          headerColor: Colors.yellow.shade600,
        ));
  }
}

class HeaderTextInfoScreen extends StatelessWidget {
  const HeaderTextInfoScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          '¿Cómo interpretar los índices?',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 24.0, color: Colors.white),
        ),
        Text(
          'GA & GGA',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 48.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
