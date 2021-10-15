class Result {
  final String filePath;
  final double gga;
  final double ga;
  final String date;
  Result(
      {required this.filePath,
      required this.gga,
      required this.ga,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      "filePath": filePath,
      "gga": gga,
      "ga": ga,
      "date": date,
    };
  }
}
