import 'package:business/classes/interest.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';

class EventGroup {
  EventGroup({
    this.id = '',
    this.name = '',
    this.interests = const <Interest>[],
    this.memberIds = const <String>[],
  });

  EventGroup.fromMap(Map<String, dynamic> snapshot, String id)
      : id = id ?? '',
        name = snapshot['name'] as String ?? '',
        interests = snapshot['interests'] == null
            ? <Interest>[]
            : (snapshot['interests'] as List<dynamic>)
                .map<Interest>((dynamic interest) => Interest.fromMap(
                    Map<String, String>.from(
                        interest as Map<dynamic, dynamic>)))
                .toList(),
        memberIds = snapshot['memberIds'] == null
            ? <String>[]
            : snapshot['memberIds'].cast<String>() as List<String>;

  String id;
  String name;
  List<String> memberIds;
  List<User> members;
  List<Interest> interests;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'interests': interests
          .map<Map<String, String>>((Interest interest) => interest.toJson())
          .toList(),
      'memberIds': memberIds,
    };
  }

  Future<void> getMembers() async {
    members = <User>[];
    for (final String memberId in memberIds) {
      final User member = await getUser(memberId);
      members.add(member);
    }
  }
}
