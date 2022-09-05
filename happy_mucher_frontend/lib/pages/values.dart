class Values {
  final double budget;
  final String total_remaining;
  Values(this.budget, this.total_remaining);

  Values.fromMap(dynamic map)
      : assert(map['budget'] != null),
        assert(map['month'] != null),
        budget = map['budget'],
        total_remaining = map['month'];

  @override
  String toString() => "Record<$budget:$total_remaining>";
}
