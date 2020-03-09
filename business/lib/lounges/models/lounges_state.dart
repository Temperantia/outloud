import 'package:business/classes/lounge.dart';

// TODO(me): only user lounges and lounges from events the user attends get fetched, so getting all of them is superfluous here
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
