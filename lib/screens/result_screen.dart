import 'dart:io';
import 'package:appgro/providers/result_provider.dart';
import 'package:appgro/widgets/navigation_bottom_bar.dart';
import 'package:appgro/widgets/screen_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final resultProvider = Provider.of<ResultProvider>(context, listen: true);

    return Scaffold(
      bottomNavigationBar: const NavigationBottomBar(1),
      body: ResultBody(resultProvider: resultProvider),
    );
  }
}

class ResultBody extends StatelessWidget {
  const ResultBody({Key? key, required this.resultProvider}) : super(key: key);
  final ResultProvider resultProvider;

  @override
  Widget build(BuildContext context) {
    const Color _primaryColor = Color.fromRGBO(20, 152, 77, 1.0);

    if (resultProvider.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Estamos procesando tu imagen...',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24.0,
                  color: Colors.grey),
            ),
            Image.asset('assets/planta.gif')
          ],
        ),
      );
    } else if (resultProvider.wasCanceled) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Has cancelado la seleccion de imagen'),
          TextButton(
            onPressed: () {
              resultProvider.saveNewTakenImage();
            },
            child: const Text('Tomar imagen de nuevo'),
          )
        ],
      ));
    } else {
      double gga = resultProvider.result!.gga;
      gga = double.parse(gga.toStringAsFixed(2));
      double ga = resultProvider.result!.ga;
      ga = double.parse(ga.toStringAsFixed(2));
      final String imagePath = resultProvider.result!.filepath;
      return ScreenWrapper(
        headerColor: _primaryColor,
        headerWidget: Column(
          children: [
            const Text(
              'Área más verde de la imagen',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24.0,
                  color: Colors.white),
            ),
            Text(
              '$gga%',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 48.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
        bodyWidget: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 20.0,
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.file(
                  File(imagePath),
                  height: 280.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              const Divider(
                height: 15,
                color: _primaryColor,
                thickness: 0.8,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Índices obtenidos de la imagen',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Card(
                      elevation: 3,
                      child: ListTile(
                        title: const Text('GGA'),
                        trailing: Text('$gga%'),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Card(
                      elevation: 3,
                      child: ListTile(
                        title: const Text('GA'),
                        trailing: Text('$ga%'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
