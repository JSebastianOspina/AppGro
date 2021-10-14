import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ResultProvider extends ChangeNotifier {
  List<dynamic> _results = [];
  double ga = 0.0;
  double gga = 0.0;
  String imagePath = '';
  String databaseName = 'resultados1.json';
  ResultProvider() {
    loadResults();
  }

  List<dynamic> get results {
    return _results;
  }

  void loadResults() async {
    final document =
        await getApplicationDocumentsDirectory(); //Get application path
    var informationFile =
        File('${document.path}/$databaseName'); //get json file
    bool fileExists = await informationFile.exists();
    if (!fileExists) {
      _results = [];
    } else {
      String jsonAsString = await informationFile.readAsString();
      _results = jsonDecode(jsonAsString) as List<dynamic>;
    }
    notifyListeners();
  }

  void deleteResult(int index) async {
    _results.removeAt(index);
    final document =
        await getApplicationDocumentsDirectory(); //Get application path
    var informationFile = File('${document.path}/$databaseName'); //get jso
    informationFile.writeAsString(jsonEncode(_results));
    notifyListeners();
  }

  void saveResult(path, imagePath, ga, gga, saveTime) async {
    var informationFile = File('$path/$databaseName');
    if (_results.isEmpty) {
      List<Map<String, dynamic>> jsonAsMap = [
        {
          "filePath": imagePath,
          "gga": gga,
          "ga": ga,
          "date": getParsedDate(saveTime),
        }
      ];
      _results = jsonAsMap;
      informationFile.writeAsString(jsonEncode(_results));
    } else {
      Map<String, dynamic> jsonAsMap = {
        "filePath": imagePath,
        "gga": gga,
        "ga": ga,
        "date": getParsedDate(saveTime),
      };
      _results.add(jsonAsMap);
      informationFile.writeAsString(jsonEncode(_results));
    }
    notifyListeners();
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
