class Ping {
  Ping.fromMap(Map<String, dynamic> snapshot, String id)
      : id = id ?? '',
        value = snapshot['value'] as int ?? 0;

  final String id;
  final int value;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'value': value,
    };
  }
}
