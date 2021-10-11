import 'package:flutter/material.dart';

class NavigationBottomBar extends StatelessWidget {
  final int currentIndex;
  const NavigationBottomBar(this.currentIndex);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 30.0,
      currentIndex: currentIndex,
      fixedColor: const Color.fromRGBO(20, 152, 77, 1.0),
      onTap: (index) {
        String _nextPage;
        switch (index) {
          case 0:
            _nextPage = 'infoScreen';
            break;
          case 1:
            _nextPage = 'resultScreen';
            break;
          case 2:
            _nextPage = 'homeScreen';
            break;
          default:
            _nextPage = 'homeScreen';
            break;
        }
        Navigator.pushNamed(context, _nextPage);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Informacion',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Tomar foto',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_add_check_rounded),
          label: 'Home',
        ),
      ],
    );
  }
}
