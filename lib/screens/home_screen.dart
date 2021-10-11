import 'package:appgro/widgets/navigation_bottom_bar.dart';
import 'package:appgro/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const NavigationBottomBar(0),
        body: ScreenWrapper(
          headerColor: Colors.brown,
          headerWidget: HeaderText(),
          bodyWidget: ListaTarjetas(),
        ));
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Imágenes analizadas',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 24.0, color: Colors.white),
        ),
        Text(
          '6',
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

class ListaTarjetas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (_, int index) {
        return ResultCard(
          index: index,
        );
      },
    );
  }
}

class ResultCard extends StatelessWidget {
  final int index;

  const ResultCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        //margin: EdgeInsets.symmetric(vertical: 15.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        color: index % 2 == 0
            ? Colors.white
            : const Color.fromRGBO(243, 242, 243, 1.0),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image(
                height: 80.0,
                width: MediaQuery.of(context).size.width * 0.35,
                fit: BoxFit.cover,
                image: AssetImage('assets/1.jpg'),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('GGA: 74.4%'),
                Text('GA: 97.8%'),
                Text('01/27/2021 04:35 PM'),
              ],
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.delete,
                  color: Colors.brown[400],
                ))
          ],
        ));
  }
}
