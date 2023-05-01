import 'package:billsplit_flutter/domain/models/group.dart';
import 'package:billsplit_flutter/domain/models/group_expense_event.dart';
import 'package:billsplit_flutter/domain/models/person.dart';
import 'package:billsplit_flutter/domain/use_cases/add_event_usecase.dart';
import 'package:billsplit_flutter/presentation/add_expense/bloc/add_expense_state.dart';
import 'package:billsplit_flutter/presentation/base/bloc/base_cubit.dart';
import 'package:billsplit_flutter/presentation/base/bloc/base_state.dart';

class AddExpenseBloc extends BaseCubit {
  final Group group;
  final GroupExpense groupExpense;
  late final _addExpenseUseCase = AddEventUseCase();

  AddExpenseBloc(this.group, this.groupExpense) : super.withState(Main());

  void onExpensesUpdated() {
    emit(Main());
  }

  void addExpense() {
    emit(Loading());
    _addExpenseUseCase.launch(group.id, groupExpense).then((value) {
      emit(AddExpenseSuccess());
    }).catchError((err) {
      showError(err);
    });
  }

  void onPayerSelected(Person person) {
    groupExpense.payerState = person;
    emit(Main());
  }

  void onQuickAddSharedExpense() {
    final sharedExpense = groupExpense.addNewSharedExpense(withParticipants: group.people);
    emit(QuickAddSharedExpense(sharedExpense));
  }

  void addExpenseForUser(Person person){
    final sharedExpense = groupExpense.addNewSharedExpense(withParticipants: [person]);
    emit(QuickAddSharedExpense(sharedExpense));
  }
}
