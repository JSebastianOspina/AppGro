import 'package:appgro/providers/result_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      //fixedColor: const Color.fromRGBO(20, 152, 77, 1.0),
      selectedItemColor: getIconColor(currentIndex),
      onTap: (index) {
        if (index == currentIndex) {
          return;
        }
        String _nextPage;
        switch (index) {
          case 0:
            _nextPage = 'homeScreen';
            break;
          case 1:
            _nextPage = 'resultScreen';
            break;
          case 2:
            _nextPage = 'infoScreen';
            break;
          default:
            _nextPage = 'homeScreen';
            break;
        }
        Navigator.pushNamed(context, _nextPage);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.library_books,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Tomar foto',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.info),
        //   label: 'Informacion',
        // ),
      ],
    );
  }

  getIconColor(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return Colors.brown;
      case 1:
        return Colors.yellow.shade700;
      case 2:
        return Colors.yellow.shade600;
    }
  }
}
