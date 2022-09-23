class Values {
  final double budget;
  final String month;
  final num totalSpent;

  Values(this.budget, this.month, this.totalSpent);

  Values.fromMap(dynamic map)
      : assert(map['budget'] != null),
        assert(map['month'] != null),
        assert(map['total spent'] != null),
        budget = map['budget'],
        month = map['month'],
        totalSpent = map['total spent'];

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
