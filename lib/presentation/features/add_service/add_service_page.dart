import 'package:billsplit_flutter/domain/models/currency.dart';
import 'package:billsplit_flutter/domain/models/group.dart';
import 'package:billsplit_flutter/domain/models/person.dart';
import 'package:billsplit_flutter/domain/models/subscription_service.dart';
import 'package:billsplit_flutter/extensions.dart';
import 'package:billsplit_flutter/presentation/common/clickable_list_item.dart';
import 'package:billsplit_flutter/presentation/common/expense_textfield/expense_textfield_controller.dart';
import 'package:billsplit_flutter/presentation/dialogs/currency_picker/currency_picker_dialog.dart';
import 'package:billsplit_flutter/presentation/features/add_service/bloc/add_service_state.dart';
import 'package:billsplit_flutter/presentation/features/add_service/bloc/add_service_bloc.dart';
import 'package:billsplit_flutter/presentation/features/add_service/widgets/service_participant_view.dart';
import 'package:billsplit_flutter/presentation/base/bloc/base_state.dart';
import 'package:billsplit_flutter/presentation/common/base_bloc_builder.dart';
import 'package:billsplit_flutter/presentation/common/base_bloc_widget.dart';
import 'package:billsplit_flutter/presentation/common/expense_textfield/default_text_field.dart';
import 'package:billsplit_flutter/presentation/common/rounded_list_item.dart';
import 'package:billsplit_flutter/presentation/dialogs/custom_dialog.dart';
import 'package:billsplit_flutter/presentation/dialogs/participant_picker/participants_picker_dialog.dart';
import 'package:billsplit_flutter/presentation/dialogs/reset_changes_dialog.dart';
import 'package:billsplit_flutter/presentation/themes/splitsby_text_theme.dart';
import 'package:billsplit_flutter/presentation/utils/routing_utils.dart';
import 'package:billsplit_flutter/utils/safe_stateful_widget.dart';
import 'package:billsplit_flutter/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class AddServicePage extends StatefulWidget {
  final SubscriptionService service;
  final Group group;

  const AddServicePage({Key? key, required this.service, required this.group})
      : super(key: key);

  @override
  State<AddServicePage> createState() => _AddServicePageState();

  static Route getRoute(
      Person user, Group group, SubscriptionService? subscriptionService) {
    if (subscriptionService == null) {
      return slideUpRoute(AddServicePage(
          group: group,
          service: SubscriptionService.newService(group: group, user: user)));
    }
    return slideUpRoute(
        AddServicePage(group: group, service: subscriptionService));
  }
}

class _AddServicePageState extends SafeState<AddServicePage> {
  late final _nameTextController =
      TextEditingController(text: widget.service.nameState);

  late final _expenseTextController = ExpenseTextFieldController(
      text: widget.service.monthlyExpenseState.fmt2dec(readOnly: false));

  bool showCannotBe0ZeroError = false;
  String? nameErrorText;

  @override
  void dispose() {
    _nameTextController.dispose();
    _expenseTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;
    return BaseBlocWidget(
      listener: (context, cubit, state) {
        if (state is ServiceAdded) {
          Navigator.of(context).pop();
        } else if (state is ServiceDeleted) {
          Navigator.of(context).pop();
        }
      },
      create: (context) => AddServiceBloc(service, widget.group),
      child: BaseBlocBuilder<AddServiceBloc>(
        builder: (cubit, state) {
          return Scaffold(
            appBar: builder(() {
              if (state is Loading) {
                return null;
              }
              return AppBar(
                  title: Builder(builder: (context) {
                    if (service.id.isEmpty) {
                      return const Text("New Subscription");
                    }
                    return const Text("Edit Subscription");
                  }),
                  leading: const BackButton(),
                  surfaceTintColor: Theme.of(context).colorScheme.surface,
                  actions: [
                    if (service.id.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                              text:
                                  "Are you sure you want to delete this subscription service?",
                              primaryText: "No, keep it",
                              onPrimaryClick: () {
                                Navigator.of(context).pop();
                              },
                              secondaryText: "Yes, delete it",
                              onSecondaryClick: () {
                                cubit.deleteService(service);
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete),
                        color: Theme.of(context).colorScheme.error,
                      ),
                    IconButton(
                      onPressed:
                          service.isChanged && service.monthlyExpenseState > 0
                              ? () {
                                  if (isValid()) {
                                    cubit.submitService();
                                  } else {
                                    showCannotBe0ZeroError = true;
                                    updateState();
                                  }
                                }
                              : null,
                      icon: const Icon(Icons.check),
                    )
                  ]);
            }),
            body: WillPopScope(
              onWillPop: () async {
                if (service.isChanged) {
                  return await showDialog(
                    context: context,
                    builder: (context) => ResetChangesDialog(
                      () {
                        service.resetChanges();
                      },
                    ),
                  );
                }
                return true;
              },
              child: Builder(builder: (context) {
                if (state is Loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 40),
                    child: Column(
                      children: [
                        RoundedListItem(
                          borderRadius: BorderRadius.circular(10),
                          child: TextField(
                            controller: _nameTextController,
                            onChanged: (value) {
                              service.nameState = value;
                              cubit.onServiceUpdated();
                            },
                            textInputAction: TextInputAction.next,
                            maxLines: 1,
                            maxLength: 30,
                            style: SplitsbyTextTheme.textFieldStyle(context),
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                                hintStyle: SplitsbyTextTheme.textFieldHintStyle(
                                    context),
                                errorText: nameErrorText,
                                counterText: "",
                                border: InputBorder.none,
                                hintText: "Enter a name. Netflix, rent, etc"),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: RoundedListItem(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                height: 64,
                                borderRadius: BorderRadius.circular(10),
                                child: ExpenseTextField(
                                    textEditingController:
                                        _expenseTextController,
                                    canBeZero: !showCannotBe0ZeroError,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.fontSize,
                                    onChange: (value) {
                                      service.monthlyExpenseState = value;
                                      cubit.onServiceUpdated();
                                    }),
                              ),
                            ),
                            const SizedBox(width: 4),
                            SizedBox(
                              height: 64,
                              width: 64,
                              child: ClickableListItem(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                onClick: () async {
                                  final response = await Navigator.of(context)
                                      .push(CurrencyPickerDialog.getRoute(
                                          convertToCurrency: cubit
                                              .group.defaultCurrencyState));
                                  if (response is Currency) {
                                    cubit.updateCurrency(response.symbol);
                                  }
                                },
                                child: Text(
                                    cubit.service.currencyState.toUpperCase()),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        RoundedListItem(
                          borderRadius: BorderRadius.circular(10),
                          height: 64,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "Participants will pay ${cubit.service.currencyState.toUpperCase()} ${_getMonthlyServicePerPerson().fmt2dec()} every month",
                                style: Theme.of(context).textTheme.labelSmall),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Builder(builder: (context) {
                          final nextMonth =
                              DateTime.now().month; // index starts at 1
                          final monthString = monthNames[
                              nextMonth]; // index starts at 0, so we get the next month by just getting the index
                          return Text(
                            "Next expense will be submitted on 1st of $monthString",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary),
                          );
                        }),
                        const SizedBox(height: 16),
                        RoundedListItem(
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(30),
                              top: Radius.circular(10)),
                          child: Column(
                            children: [
                              ...service.participantsState.mapIndexed(
                                (i, e) {
                                  if (i > 0) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: ServiceParticipantView(person: e),
                                    );
                                  }
                                  return ServiceParticipantView(person: e);
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  onPressed: () async {
                                    final response = await showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Theme.of(context).colorScheme.surface,
                                      builder: (context) =>
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: ParticipantsPickerDialog(
                                              participants: service.participantsState,
                                              people: cubit.group.people,
                                            ),
                                          ),
                                    );
                                    if (response is List<Person>) {
                                      cubit.updateParticipants(response);
                                    }
                                  },
                                  icon: const Icon(Icons.group),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }

  bool isValid() {
    if (_nameTextController.text.isEmpty) {
      nameErrorText = "Enter a name";
    } else {
      nameErrorText = null;
    }

    try {
      return _nameTextController.text.isNotEmpty &&
          _expenseTextController.text.isNotEmpty &&
          num.parse(_expenseTextController.text) > 0;
    } catch (e) {
      return false;
    }
  }

  num _getMonthlyServicePerPerson() {
    try {
      return widget.service.monthlyExpenseState /
          widget.service.participantsState.length;
    } catch (e) {
      return 0;
    }
  }
}
