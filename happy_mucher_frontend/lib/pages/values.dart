class Values {
  final double budget;
  final String month;

  Values(this.budget, this.month);

  Values.fromMap(dynamic map)
      : assert(map['budget'] != null),
        assert(map['month'] != null),
        budget = map['budget'],
        month = map['month'];

  @override
  String toString() => "Record<$budget:$month>";
}

class GLValues {
  final String type;
  final num shoppingTotal;

  GLValues(this.type, this.shoppingTotal);

  GLValues.fromMap(dynamic map)
      : assert(map['type'] != null),
        assert(map['total'] != null),
        type = map['type'],
        shoppingTotal = map['total'];
}
