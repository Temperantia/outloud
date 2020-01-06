class Group {
  Group({this.id, this.name});

  Group.fromMap(Map snapshot, String id)
      : id = id ?? '',
        name = snapshot['name'] ?? '';

  final String id;
  final String name;

  toJson() {
    return {
      'name': name,
    };
  }
}