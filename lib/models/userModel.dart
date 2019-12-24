class User {
  String id;
  String device;
  String name;
  String email;
  DateTime birth;
  String pics;

User({this.id, this.device, this.name, this.email, this.birth, this.pics});

  User.fromMap(Map snapshot, String id) :
        id = id ?? '',
        device = snapshot['device'] ?? '',
        name = snapshot['name'] ?? '',
        email = snapshot['email'] ?? '',
        birth = snapshot['birth'] ?? '',
        pics = snapshot['pics'] ?? '';

  toJson() {
    return {
      "device": device,
      "name": name,
      "email": email,
      "birth": birth,
      "pics": pics,
    };
  }
}