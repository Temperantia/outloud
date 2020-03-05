import 'package:business/classes/lounge.dart';

class LoungesState {
  LoungesState({
    this.lounges,
  });

  LoungesState copy({
    List<Lounge> lounges,
  }) =>
      LoungesState(
        lounges: lounges ?? this.lounges,
      );

  final List<Lounge> lounges;

  static LoungesState initialState() {
    return LoungesState();
  }
}
