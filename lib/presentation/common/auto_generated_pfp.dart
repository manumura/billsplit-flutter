import 'package:billsplit_flutter/domain/models/person.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutoGeneratedProfilePicture extends StatelessWidget {
  final Person person;
    final double size;

  const AutoGeneratedProfilePicture(
      {super.key, required this.person, required this.size});

  @override
  Widget build(BuildContext context) {
    final userName = person.nameState;
    final String displayName;
    if (userName.trim().contains(" ")) {
      final split = userName.split(" ").where((element) => element.isNotEmpty);
      final initials = split
          .map((e) => e[0])
          .fold("", (previousValue, element) => "$previousValue$element");
      displayName = initials.toUpperCase();
    } else {
      displayName = userName[0].toUpperCase();
    }
    final color = Color(person.uid.hashCode << 10);
    return ClipOval(
      child: Container(
        alignment: Alignment.center,
        height: size,
        width: size,
        color: color,
        child: Text(displayName,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: (size / 2.5))),
      ),
    );
  }
}
