import 'dart:convert';
import 'dart:io';

import 'package:appgro/providers/result_provider.dart';
import 'package:appgro/widgets/navigation_bottom_bar.dart';
import 'package:appgro/widgets/screen_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resultProvider = Provider.of<ResultProvider>(context);

    return Scaffold(
        bottomNavigationBar: const NavigationBottomBar(0),
        body: ScreenWrapper(
          headerColor: Colors.brown,
          headerWidget: HeaderText(resultProvider: resultProvider),
          bodyWidget: ListaTarjetas(resultProvider: resultProvider),
        ));
  }
}

class HeaderText extends StatelessWidget {
  final ResultProvider resultProvider;

  const HeaderText({Key? key, required this.resultProvider}) : super(key: key);
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
          '${resultProvider.results.length}',
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
  final ResultProvider resultProvider;

  const ListaTarjetas({Key? key, required this.resultProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> results = resultProvider.results;

    if (results.isEmpty) {
      return const Center(
        child: Text("Por favor, toma una foto"),
      );
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, int index) {
        return ResultCard(
            index: index,
            individualResult: results[index],
            resultProvider: resultProvider);
      },
    );
  }
}

class ResultCard extends StatelessWidget {
  final int index;
  final Map individualResult;
  final ResultProvider resultProvider;

  const ResultCard(
      {Key? key,
      required this.index,
      required this.individualResult,
      required this.resultProvider})
      : super(key: key);

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
              child: Image.file(
                File(individualResult['filePath']),
                height: 80.0,
                width: MediaQuery.of(context).size.width * 0.35,
                fit: BoxFit.fill,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'GGA: ${double.parse(individualResult['gga'].toStringAsFixed(2))}%'),
                Text(
                    'GA: ${double.parse(individualResult['ga'].toStringAsFixed(2))}%'),
                Text('${individualResult['date']}'),
              ],
            ),
            IconButton(
                onPressed: () {
                  resultProvider.deleteResult(index);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.brown[400],
                ))
          ],
        ));
  }
}
