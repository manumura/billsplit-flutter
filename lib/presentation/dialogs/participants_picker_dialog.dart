import 'package:billsplit_flutter/domain/models/person.dart';
import 'package:billsplit_flutter/presentation/common/pfp_view.dart';
import 'package:flutter/material.dart';

class ParticipantsPickerDialog extends StatefulWidget {
  final List<Person> participants;
  final Iterable<Person> people;
  final Widget? extraAction;

  const ParticipantsPickerDialog({
    Key? key,
    required this.participants,
    required this.people,
    this.extraAction,
  }) : super(key: key);

  @override
  State<ParticipantsPickerDialog> createState() =>
      _ParticipantsPickerDialogState();
}

class _ParticipantsPickerDialogState extends State<ParticipantsPickerDialog> {
  void changeParticipantStatus(Person person, bool isParticipant) {
    if (isParticipant) {
      widget.participants.add(person);
    } else {
      widget.participants.remove(person);
    }
  }

  bool showMin1PersonError = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...widget.people.map(
              (person) => Row(
                children: [
                  ProfilePictureView(person: person),
                  const SizedBox(width: 16),
                  Text(person.nameState),
                  const Expanded(child: SizedBox()),
                  Checkbox(
                      value: widget.participants.contains(person),
                      onChanged: (isParticipant) {
                        if (isParticipant == false &&
                            widget.participants.length == 1) {
                          // cannot have 0 participants
                          showMin1PersonError = true;
                        } else {
                          showMin1PersonError = false;
                          changeParticipantStatus(
                              person, isParticipant ?? false);
                        }
                        setState(() {});
                      })
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (showMin1PersonError)
              Text(
                "Must include at least one person",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.error),
              ),
            Row(
              children: [
                widget.extraAction ?? const SizedBox(),
                const Expanded(child: SizedBox()),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Theme.of(context).colorScheme.primary,
                    icon: const Icon(Icons.check))
              ],
            )
          ],
        ),
      ),
    );
  }
}
