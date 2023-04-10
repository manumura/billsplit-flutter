import 'package:billsplit_flutter/domain/models/person.dart';

class IndividualExpense {
  final Person person;
  num expense;
  bool isParticipant;

  IndividualExpense(
      {required this.person, this.expense = 0, this.isParticipant = false});

  IndividualExpense.sharedExpense(num sharedExpense)
      : this(person: Person("", "Shared", ""), expense: sharedExpense);

  @override
  String toString() {
    return "IndividualExpense(person=$person, expense=$expense, isParticipant=$isParticipant)";
  }
}