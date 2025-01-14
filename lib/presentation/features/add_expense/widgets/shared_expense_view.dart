import 'dart:math';

import 'package:billsplit_flutter/domain/models/person.dart';
import 'package:billsplit_flutter/domain/models/shared_expense.dart';
import 'package:billsplit_flutter/presentation/common/expense_textfield/default_text_field.dart';
import 'package:billsplit_flutter/presentation/common/expense_textfield/expense_textfield_controller.dart';
import 'package:billsplit_flutter/presentation/common/profile_picture_stack.dart';
import 'package:billsplit_flutter/presentation/common/rounded_list_item.dart';
import 'package:billsplit_flutter/presentation/dialogs/participant_picker/participants_picker_dialog.dart';
import 'package:billsplit_flutter/presentation/features/add_expense/bloc/add_expense_bloc.dart';
import 'package:billsplit_flutter/presentation/features/add_expense/widgets/shared_expense_description_view.dart';
import 'package:billsplit_flutter/presentation/mutable_state.dart';
import 'package:billsplit_flutter/presentation/utils/routing_utils.dart';
import 'package:billsplit_flutter/utils/list_position.dart';
import 'package:billsplit_flutter/utils/safe_stateful_widget.dart';
import 'package:billsplit_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SharedExpenseView extends StatefulWidget {
  final SharedExpense sharedExpense;
  final bool autoFocus;
  final ListPosition listPosition;
  final String hintText;


  const SharedExpenseView({
    super.key,
    required this.sharedExpense,
    required this.hintText,
    this.autoFocus = false,
    required this.listPosition,
  });

  @override
  State<SharedExpenseView> createState() => _SharedExpenseViewState();
}

class _SharedExpenseViewState extends SafeState<SharedExpenseView> {
  late final textController = ExpenseTextFieldController(
      text: widget.sharedExpense.expenseState.value.fmtTextField());
  final double participantsIconSize = 20;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddExpenseBloc>();
    return Builder(builder: (context) {
      final showAnimation =
          cubit.groupExpense.sharedExpensesState.value.length > 1 &&
              !cubit.sharedPrefs.hasDeletedSharedExpense;
      return Column(
        children: [
          Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onUpdate: (details) {
              if (details.direction == DismissDirection.endToStart) {
                cubit.sharedPrefs.hasDeletedSharedExpense = true;
              }
            },
            onDismissed: (direction) {
              cubit.removeSharedExpense(widget.sharedExpense);
            },
            background: RoundedListItem(
              color: Theme
                  .of(context)
                  .colorScheme
                  .background,
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Icon(Icons.delete,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .error),
                ],
              ),
            ),
            child: RoundedListItem(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 8,
                        child: SharedExpenseDescriptionView(
                          key: UniqueKey(),
                          hintText: "ex. ${widget.hintText}",
                          showIcon: false,
                          sharedExpense: widget.sharedExpense,
                        ),
                      ),
                      MutableValue(
                          mutableValue: cubit.groupExpense.currencyState,
                          builder: (context, currency) {
                            return Expanded(
                              flex: 5,
                              child: ExpenseTextField(
                                showErrorText: false,
                                canBeZero: true,
                                fontSize: Theme
                                    .of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.fontSize,
                                prefix: currency.symbol.toUpperCase(),
                                onChange: (value) {
                                  cubit.updateSharedExpense(
                                      widget.sharedExpense, value);
                                },
                                autoFocus: widget.autoFocus,
                                textEditingController: textController,
                              ),
                            );
                          }),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      _editParticipants(context);
                    },
                    style: ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        padding: WidgetStateProperty.resolveWith(
                                (states) => EdgeInsets.zero)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MutableValue(
                            mutableValue:
                            widget.sharedExpense.participantsState,
                            builder: (context, participants) {
                              return ProfilePictureStack(
                                people: participants,
                                size: participantsIconSize,
                                limit: 4,
                              );
                            }),
                        const Expanded(
                          child: SizedBox(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ).animate(
              autoPlay: showAnimation,
              delay: 1000.ms,
              effects: [
                SlideEffect(
                    begin: Offset.zero,
                    end: const Offset(-0.1, 0),
                    duration: 100.ms,
                    curve: Curves.fastLinearToSlowEaseIn),
                SlideEffect(
                    delay: 1000.ms,
                    end: const Offset(0.1, 0),
                    duration: 100.ms,
                    curve: Curves.fastLinearToSlowEaseIn)
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      );
    });
  }

  void _editParticipants(BuildContext context) async {
    final cubit = context.read<AddExpenseBloc>();
    final route = ParticipantsPickerDialog(
        participantsState: widget.sharedExpense.participantsState,
        peopleState: cubit.peopleStream,
        currencySymbol: cubit.groupExpense.currencyState.value.symbol,
        totalExpense: cubit.groupExpense.total,
        description: widget.sharedExpense.descriptionState.value,
        onAddTempParticipant: (name) {
          cubit.onAddTempParticipant(name, widget.sharedExpense);
        });
    await Navigator.of(context).push(slideUpRoute(route, duration: 100));
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
