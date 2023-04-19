import 'package:billsplit_flutter/domain/models/person.dart';
import 'package:billsplit_flutter/presentation/add_group/bloc/add_group_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddedPersonView extends StatelessWidget {
  final Person person;

  const AddedPersonView({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddGroupCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(person.nameState),
        IconButton(
            onPressed: () {
              cubit.removePerson(person);
            },
            color: Colors.red,
            icon: const Icon(Icons.remove))
      ],
    );
  }
}