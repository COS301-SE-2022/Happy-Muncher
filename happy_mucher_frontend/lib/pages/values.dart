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
  final num total;
  final String type;

  GLValues(this.type, this.total);

  GLValues.fromMap(dynamic map)
      : assert(map['type'] != null),
        assert(map['total'] != null),
        type = map['type'],
        total = map['total'];
}
