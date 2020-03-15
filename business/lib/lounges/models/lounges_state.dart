import 'package:business/classes/lounge.dart';

class LoungesState {
  LoungesState({
    this.lounges,
    this.loungeCreation,
  });

  LoungesState copy({
    List<Lounge> lounges,
    Lounge loungeCreation,
  }) =>
      LoungesState(
        lounges: lounges ?? this.lounges,
        loungeCreation: loungeCreation ?? this.loungeCreation,
      );

  final List<Lounge> lounges;
  final Lounge loungeCreation;

  static LoungesState initialState() {
    return LoungesState();
  }
}
