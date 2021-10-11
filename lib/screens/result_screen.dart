import 'package:appgro/providers/indexes_provider.dart';
import 'package:appgro/widgets/navigation_bottom_bar.dart';
import 'package:appgro/widgets/screen_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const String _imagePath = 'assets/2.jpg';
    const Color _primaryColor = Color.fromRGBO(20, 152, 77, 1.0);
    return Scaffold(
        bottomNavigationBar: const NavigationBottomBar(1),
        body: FutureBuilder(
            future: getIndexes(),
            builder: (context, AsyncSnapshot<List<double>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              } else {
                final indexes = snapshot.data;
                double gga = indexes![0];
                gga = double.parse(gga.toStringAsFixed(2));
                double ga = indexes[1];
                ga = double.parse(ga.toStringAsFixed(2));
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
                        '$gga',
                        style: TextStyle(
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
                          child: Image(
                            height: 280.0,
                            fit: BoxFit.cover,
                            image: AssetImage(_imagePath),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Divider(
                          height: 15,
                          color: _primaryColor,
                          thickness: 0.8,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Índices obtenidos de la imagen',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Card(
                                elevation: 3,
                                child: ListTile(
                                  title: Text('GGA'),
                                  trailing: Text('$gga'),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Card(
                                elevation: 3,
                                child: ListTile(
                                  title: Text('GA'),
                                  trailing: Text('$ga'),
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
            }));
  }

  Future<List<double>> getIndexes() async {
    final String _fakeImagePath = 'assets/1.jpg';
    var list = await FlutterImageCompress.compressAssetImage(
      _fakeImagePath,
      //quality: 75
    );
    final gga = getGGA(list!);
    final ga = getGA(list);
    return [gga, ga];
  }
}
