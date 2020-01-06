class Ping {
  String id;
  int value;

  Ping.fromMap(Map snapshot, String id)
      : id = id ?? '',
        value = snapshot['value'] ?? 0;

  toJson() {
    return {
      'id': id,
      'value': value,
    };
  }
}