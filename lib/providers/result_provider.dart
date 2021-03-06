import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:appgro/models/result_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'indexes_provider.dart';

class ResultProvider extends ChangeNotifier {
  List<Result> _results = [];
  Result? _actualResult;
  bool _isLoading;
  bool _wasCanceled;
  String databaseName = 'resultados1.json';
  ResultProvider()
      : _isLoading = false,
        _wasCanceled = false {
    loadResults();
  }
  set result(Result? result) {
    _isLoading = false;
    _wasCanceled = false;
    _actualResult = result;
    notifyListeners();
  }

  Result? get lastResult {
    return _results[_results.length - 1];
  }

  Result? get result {
    return _actualResult;
  }

  bool get hasResults {
    return _results.isNotEmpty;
  }

  bool get wasCanceled {
    return _wasCanceled;
  }

  Future<Uint8List?> getUserImageAsUint8List() async {
    final ImagePicker _picker = ImagePicker();
    //Ask to promp the user gallery and select a photo
    final XFile? userGalleryImage =
        await _picker.pickImage(source: ImageSource.gallery);
    //if the user canceled the operation, return null.
    if (userGalleryImage == null) {
      return null;
    }
    //if it's not null, the user selected an imagen, lets
    //return it as Uint8List
    return userGalleryImage.readAsBytes();
  }

  void saveNewTakenImage() async {
    //The process start, tell all the widgets to show loading effect
    _isLoading = true;
    notifyListeners();
    //Read the taken image as bytes.
    final Uint8List? imageBytes = await getUserImageAsUint8List();
    //If reciceive null, means that the user canceled the operation
    //So, stop loading and show _wasCanceled message in UI
    if (imageBytes == null) {
      _isLoading = false;
      _wasCanceled = true;
      notifyListeners();
      return;
    }
    //Compress the image with 70% quality
    var compressedImage = await FlutterImageCompress.compressWithList(
      imageBytes,
      quality: 70,
    );

    //Starts a new processor that gets the compressed image Ga and GGA
    // final gga = await compute(getGGA, compressedImage);
    // final ga = await compute(getGA, compressedImage);

    final ggaAndGa = await Future.wait(
        [compute(getGGA, compressedImage), compute(getGA, compressedImage)]);
    final gga = ggaAndGa[0];
    final ga = ggaAndGa[1];

    final date = DateTime.now();
    final dateAsString = getParsedDate(date);
    //At this poing, we got all the variables we need for saving
    //and displaying the result

    //get the application path in order to save it.
    final applicationPath = await getApplicationPath();
    // Make the final image path
    final String imageName = '$applicationPath/${date.toString()}.jpg';
    //Save compressed image to user device
    File(imageName).writeAsBytes(compressedImage);
    saveResult(applicationPath, imageName, ga, gga, dateAsString);
    _isLoading = false;
    _wasCanceled = false;
  }

  List<dynamic> get results {
    return _results;
  }

  bool get isLoading {
    return _isLoading;
  }

  void loadResults() async {
    final applicationPath = await getApplicationPath(); //Get application path
    var jsonFile = File('$applicationPath/$databaseName'); //get json file
    bool fileExists = await jsonFile.exists();
    if (!fileExists) {
      _results = [];
    } else {
      String jsonAsString = await jsonFile.readAsString();
      //Convert to JsonObject
      List<dynamic> jsonAsObject = jsonDecode(jsonAsString);
      Iterable<Result> iterableResults =
          jsonAsObject.map((jsonResult) => Result(
                filePath: jsonResult['filePath'],
                gga: jsonResult['gga'],
                ga: jsonResult['ga'],
                date: jsonResult['date'],
              ));
      List<Result> resultList = iterableResults.toList();
      //Load the previus results into _result vartiable
      _results = resultList;
    }
    notifyListeners();
  }

  void deleteResult(int index) async {
    _results.removeAt(index);
    final applicationPath = await getApplicationPath(); //Get application path
    var informationFile = File('$applicationPath/$databaseName'); //get jso
    if (_results.isEmpty) {
      informationFile.writeAsString(jsonEncode([]));
    } else {
      informationFile.writeAsString(
          jsonEncode(resultListToMapList(_results as List<Result>)));
    }

    notifyListeners();
  }

  void saveResult(path, imagePath, ga, gga, saveTime) async {
    var informationFile = File('$path/$databaseName');
    _actualResult =
        Result(filePath: imagePath, ga: ga, gga: gga, date: saveTime);
    if (_results.isEmpty) {
      //Create the result List with this map.
      _results = [_actualResult!];
      //Of course, save it :)

      informationFile.writeAsString(jsonEncode([]));
    } else {
      //Append the new item to the current result's list.
      _results.add(_actualResult!);
      //Of course, save it :)
      informationFile.writeAsString(
          jsonEncode(resultListToMapList(_results as List<Result>)));
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> resultListToMapList(List<Result> resultList) {
    Iterable<Map<String, dynamic>> resultIterable =
        resultList.map((Result result) {
      return result.toMap();
    });
    return resultIterable.toList();
  }

  Future<String> getApplicationPath() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    return documentDirectory.path;
  }

  String getParsedDate(DateTime saveTime) {
    String y = '${saveTime.year}';
    String m = '${saveTime.month}';
    String d = '${saveTime.day}';
    String h = '${saveTime.hour}';
    String min = '${saveTime.minute}';

    return "$y-$m-$d $h:$min";
  }
}
