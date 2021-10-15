class Result {
  final String filepath;
  final double gga;
  final double ga;
  final DateTime date;
  Result(
      {required this.filepath,
      required this.gga,
      required this.ga,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      "filePath": filepath,
      "gga": gga,
      "ga": ga,
      "date": getParsedDate(date),
    };
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
