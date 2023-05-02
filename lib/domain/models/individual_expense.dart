import 'package:billsplit_flutter/domain/models/person.dart';

class IndividualExpense {
  final Person person;
  final num _expense;

  // modifiable values
  late num expenseState = _expense;

  IndividualExpense({required this.person, num expense = 0})
      : _expense = expense;

  IndividualExpense.sharedExpense(num sharedExpense)
      : this(
      person: Person("", "Shared", pfpUrl: "https://i.imgur.com/S1HrKqU.png"),
      expense: sharedExpense);

  @override
  String toString() {
    return "IndividualExpense(person=$person, expense=$expenseState)";
  }

  @override
  bool operator ==(Object other) {
    if(other is! IndividualExpense) return false;
    return person == other.person;
  }

  bool get isChanged {
    return _expense != expenseState;
  }

  void resetChanges() {
    expenseState = _expense;
  }

  @override
  int get hashCode => person.uid.hashCode;

}
