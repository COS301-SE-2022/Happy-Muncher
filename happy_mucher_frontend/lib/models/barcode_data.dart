class BarcodeData {
  final String name;
  BarcodeData({
    this.name = "",
  });

  factory BarcodeData.fromJson(dynamic data) {
    //calories @ [9] ???
    String nme = "";

    if (data['title'] != null) {
      nme = data['title'] as String;
    }

    return BarcodeData(
      name: nme,
    );
  }
  static List<BarcodeData> snapshotBarcode(List snapshot) {
    //return snapshot.map((dat) => Recipe.fromJson(dat)).toList();
    return snapshot.map((content) {
      return BarcodeData.fromJson(content);
    }).toList();
  }

  @override
  String toString() {
    return 'Name {name: $name';
  }
}
