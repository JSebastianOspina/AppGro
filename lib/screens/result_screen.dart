import 'package:appgro/providers/indexes_provider.dart';
import 'package:appgro/widgets/navigation_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const double _gga = 74.478;
    const double _ga = 98.271;
    const String _imagePath = 'assets/2.jpg';
    const Color _primaryColor = Color.fromRGBO(20, 152, 77, 1.0);
    return Scaffold(
        bottomNavigationBar: const NavigationBottomBar(1),
        body: Container(
          width: double.infinity,
          color: _primaryColor,
          child: FutureBuilder(
              future: getIndexes(),
              builder: (context, AsyncSnapshot<List<double>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                    // child: CircularProgressIndicator(
                    //   color: Colors.white,
                    // ),
                  );
                } else {
                  final indexes = snapshot.data;
                  double gga = indexes![0];
                  gga = double.parse(gga.toStringAsFixed(2));
                  double ga = indexes[1];
                  ga = double.parse(ga.toStringAsFixed(2));
                  return Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
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
                      const SizedBox(height: 10.0),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            width: double.infinity,
                            child: Padding(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                          ),
                        ),
                      )
                    ],
                  );
                }
              }),
        ));
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
