class Values {
  final String budget;
  final num total_remaining;
  Values(this.budget, this.total_remaining);

  Values.fromMap(dynamic map)
      : assert(map['budget'] != null),
        assert(map['total remaining'] != null),
        budget = map['budget'],
        total_remaining = map['total remaining'];

  @override
  String toString() => "Record<$budget:$total_remaining>";
}
