import 'package:flutter/material.dart';

import '../../../domain/models/group.dart';
import '../../group/group_page.dart';

class GroupView extends StatelessWidget {
  final Group group;

  const GroupView({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      child: Center(
        child: MaterialButton(
          onPressed: () => _onClick(context),
          minWidth: double.infinity,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.cyan,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  Text(group.name),
                  Text(group.createdBy.name),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onClick(BuildContext context) {
    Navigator.of(context)
        .pushNamed(GroupPage.route, arguments: {"group_id": group.id});
  }
}
