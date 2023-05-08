import 'package:billsplit_flutter/domain/models/individual_expense.dart';
import 'package:billsplit_flutter/presentation/features/add_expense/bloc/add_expense_bloc.dart';
import 'package:billsplit_flutter/presentation/common/payer_view.dart';
import 'package:billsplit_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndividualExpenseView extends StatefulWidget {
  final IndividualExpense individualExpense;

  const IndividualExpenseView(this.individualExpense, {super.key});

  @override
  State<IndividualExpenseView> createState() => _IndividualExpenseViewState();
}

class _IndividualExpenseViewState extends State<IndividualExpenseView> {
  late final textController =
      TextEditingController(text: "${widget.individualExpense.expenseState}");

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddExpenseBloc>();
    final nameShort = widget.individualExpense.person
        .nameState;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PayerView(
          person: widget.individualExpense.person,
          isPayer: _isPayer(widget.individualExpense, cubit),
          size: 50,
          onClick: () {
            cubit.onPayerSelected(widget.individualExpense.person);
          },
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Builder(
                        builder: (context) {
                          String buttonText = nameShort;
                          if (cubit.groupExpense.payerState.uid ==
                              widget.individualExpense.person.uid) {
                            buttonText = "$nameShort is paying";
                          }
                          return MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            onPressed: () {
                              cubit.onPayerSelected(
                                  widget.individualExpense.person);
                            },
                            onLongPress: () {
                              HapticFeedback.heavyImpact();

                              cubit.addExpenseForUser(
                                  widget.individualExpense.person);
                            },
                            visualDensity: VisualDensity.compact,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                buttonText,
                                maxLines: 2,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Builder(builder: (context) {
                        final totalForUser = getTotalForUser(cubit).fmt2dec();
                        if (totalForUser.length > 13) {
                          return Text(
                            "\$${totalForUser.substring(0, totalForUser.length - 1)}...",
                            style: Theme.of(context).textTheme.titleMedium,
                          );
                        } else {
                          if (getTotalForUser(cubit) > 0) {
                            return Text(
                              "\$${getTotalForUser(cubit).fmt2dec()}",
                              style: Theme.of(context).textTheme.titleMedium,
                            );
                          }
                          return const SizedBox();
                        }
                      }),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  num getTotalForUser(AddExpenseBloc cubit) {
    return widget.individualExpense.expenseState +
        cubit.groupExpense
            .getSharedExpensesForPerson(widget.individualExpense.person);
  }

  bool _isPayer(IndividualExpense individualExpense, AddExpenseBloc cubit) {
    return cubit.groupExpense.payerState.uid == individualExpense.person.uid;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}