import 'package:billsplit_flutter/domain/models/person.dart';
import 'package:billsplit_flutter/presentation/common/pfp_view.dart';
import 'package:billsplit_flutter/presentation/dialogs/participant_picker/temporary_participant_view.dart';
import 'package:billsplit_flutter/presentation/mutable_state.dart';
import 'package:billsplit_flutter/presentation/themes/splitsby_text_theme.dart';
import 'package:billsplit_flutter/utils/utils.dart';
import 'package:flutter/material.dart';

class ParticipantsPickerDialog extends StatelessWidget {
  final MutableListState<Person> participantsState;
  final MutableState<Iterable<Person>> people;
  final num totalExpense;
  final String currencySymbol;
  final Widget? extraAction;
  final String description;
  final bool showSubmit;
  final Function(String)? onAddTempParticipant;

  const ParticipantsPickerDialog({
    super.key,
    required this.participantsState,
    required this.people,
    required this.totalExpense,
    required this.currencySymbol,
    required this.description,
    this.showSubmit = true,
    this.onAddTempParticipant,
    this.extraAction,
  });

  final _showMin1PersonError = false;

  void changeParticipantStatus(Person person, bool isParticipant) {
    if (isParticipant) {
      participantsState.add(person);
    } else {
      participantsState.remove(person);
    }
  }

  bool _isEveryoneSelected(int peopleSize) =>
      peopleSize == participantsState.value.length;

  @override
  Widget build(BuildContext context) {
    final allowTempParticipants = onAddTempParticipant != null;
    return MutableValue<Iterable<Person>>(
      mutableValue: people,
      builder: (context, people) {
        return MutableValue(
            mutableValue: participantsState,
            builder: (context, participants) {
              return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.surface,
                appBar: _appBar(context, people),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 4),
                        ...people.map(
                          (person) => _participantView(context, person),
                        ),
                        if (allowTempParticipants) const SizedBox(height: 8),
                        if (allowTempParticipants)
                          TemporaryParticipantView(
                            onAddTempParticipant: onAddTempParticipant,
                          ),
                        const SizedBox(height: 8),
                        if (_showMin1PersonError)
                          Text(
                            "Must include at least one person",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context).colorScheme.error),
                          ),
                        if (extraAction != null) const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [if (extraAction != null) extraAction!],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  AppBar _appBar(BuildContext context, Iterable<Person> people) {
    return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      title: Text(description),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        disabledColor: Theme.of(context).disabledColor,
        color: Theme.of(context).colorScheme.onSurface,
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        if (showSubmit)
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(participantsState.value);
            },
            disabledColor: Theme.of(context).disabledColor,
            color: Theme.of(context).colorScheme.onSurface,
            icon: const Icon(Icons.check),
          )
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  "tip: tap a friend to select only them!",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
              Checkbox(
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.disabled)) {
                    return Theme.of(context).colorScheme.inversePrimary;
                  }
                  return Theme.of(context).colorScheme.secondaryContainer;
                }),
                tristate: true,
                value: (_isEveryoneSelected(people.length)) ? true : null,
                onChanged: _isEveryoneSelected(people.length)
                    ? null
                    : (value) {
                        if (value == false) {
                          participantsState.clear();
                          participantsState.addAll(people);
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _participantView(BuildContext context, Person person) {
    num amount = 0;
    final isParticipant = participantsState.value.contains(person);
    if (totalExpense > 0 && isParticipant) {
      amount = totalExpense / participantsState.value.length;
    }
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  participantsState.clear();
                  participantsState.add(person);
                },
                child: Row(
                  children: [
                    ProfilePictureView(person: person),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              person.displayName,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.titleSmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Text(
                                  currencySymbol,
                                  style:
                                      SplitsbyTextTheme.groupViewDebtCurrency(
                                          context),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  amount.fmt2dec(),
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 32),
            Checkbox(
              fillColor: WidgetStateProperty.resolveWith((states) {
                return Theme.of(context).colorScheme.secondaryContainer;
              }),
              value: participantsState.value.contains(person),
              onChanged: (isParticipant) {
                if (isParticipant == false &&
                    participantsState.value.length == 1) {
                  // cannot have 0 participants
                } else {
                  changeParticipantStatus(person, isParticipant ?? false);
                }
              },
            )
          ],
        ),
        const SizedBox(height: 16)
      ],
    );
  }
}
