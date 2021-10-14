import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:appgro/providers/indexes_provider.dart';
import 'package:appgro/providers/result_provider.dart';
import 'package:appgro/widgets/navigation_bottom_bar.dart';
import 'package:appgro/widgets/screen_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Color _primaryColor = Color.fromRGBO(20, 152, 77, 1.0);
    final resultProvider = Provider.of<ResultProvider>(context, listen: false);

    return Scaffold(
        bottomNavigationBar: const NavigationBottomBar(1),
        body: FutureBuilder(
            future: getImageFromUserCamera(context, resultProvider),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (!snapshot.hasData) {
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
              } else {
                final indexes = snapshot.data;
                double gga = indexes![0];
                gga = double.parse(gga.toStringAsFixed(2));
                double ga = indexes[1];
                ga = double.parse(ga.toStringAsFixed(2));
                final String imagePath = indexes[2];
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
                          child: Image.file(
                            File(imagePath),
                            height: 280.0,
                            fit: BoxFit.cover,
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
                                  trailing: Text('$gga%'),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Card(
                                elevation: 3,
                                child: ListTile(
                                  title: Text('GA'),
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
            }));
  }

  Future<List<dynamic>> getImageFromUserCamera(
      context, ResultProvider resultprovider) async {
    final ImagePicker _picker = ImagePicker(); //Create ImagePicker Instance
    final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery); //Ask to promp the user gallery
    final document =
        await getApplicationDocumentsDirectory(); //Get application document folder
    final Uint8List imageBytes =
        await photo!.readAsBytes(); //Read the taken image as bytes.
    var compressedImage = await FlutterImageCompress.compressWithList(
        imageBytes,
        quality: 70); //Compress the image
    final gga = await compute(getGGA, compressedImage); //Calculate gga and ga
    final ga = await compute(getGA, compressedImage);
    final String imageName =
        '${document.path}/${photo.name}'; //Get the image path
    File(imageName).writeAsBytes(compressedImage); //Save image to user device
    final date = DateTime.now(); //Get the actual time
    resultprovider.saveResult(document.path, imageName, ga, gga, date);
    return [gga, ga, imageName];
    //Guardar la información.
  }
}
