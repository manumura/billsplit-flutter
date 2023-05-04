import 'dart:async';

import 'package:billsplit_flutter/domain/models/event.dart';
import 'package:billsplit_flutter/domain/models/group.dart';
import 'package:billsplit_flutter/domain/models/person.dart';
import 'package:billsplit_flutter/domain/models/subscription_service.dart';
import 'package:billsplit_flutter/domain/use_cases/add_group_usecase.dart';
import 'package:billsplit_flutter/domain/use_cases/add_person_to_group_usecase.dart';
import 'package:billsplit_flutter/domain/use_cases/get_group_usecase.dart';
import 'package:billsplit_flutter/domain/use_cases/leave_group_usecase.dart';
import 'package:billsplit_flutter/domain/use_cases/observe_debts_usecase.dart';
import 'package:billsplit_flutter/domain/use_cases/observe_events_usecase.dart';
import 'package:billsplit_flutter/domain/use_cases/observe_services_usecase.dart';
import 'package:billsplit_flutter/presentation/base/bloc/base_cubit.dart';
import 'package:billsplit_flutter/presentation/base/bloc/base_state.dart';
import 'package:billsplit_flutter/presentation/group/bloc/group_state.dart';
import 'package:billsplit_flutter/utils/pair.dart';
import 'package:collection/collection.dart';

class GroupBloc extends BaseCubit {
  final _getGroupUseCase = GetGroupUseCase();
  final _observeEventsUseCase = ObserveEventsUseCase();
  final _observeServicesUseCase = ObserveServicesUseCase();
  final _observeDebtsUseCase = ObserveDebtsUseCase();
  final _leaveGroupUseCase = LeaveGroupUseCase();
  final _addPersonToGroupUseCase = AddPersonToGroupUseCase();
  final _addGroupUseCase = AddGroupUseCase();

  final Group group;
  GroupPageNav navIndex = GroupPageNav.events;
  EditGroupNameState editGroupNameState = EditGroupNameState.display;

  GroupBloc(this.group) : super.withState(SyncingGroup(GroupPageNav.events));

  Stream<List<Event>> getEventsStream() =>
      _observeEventsUseCase.observe(group.id).map((event) =>
          event.toList().sortedBy((e) => e.timestamp).reversed.toList());

  Stream<List<SubscriptionService>> getServicesStream() =>
      _observeServicesUseCase.observe(group.id).map(
          (event) => event.toList().sortedBy((element) => element.nameState));

  Stream<Iterable<Pair<Person, num>>> getDebtsStream() =>
      _observeDebtsUseCase.observe(group.id);

  void loadGroup() async {
    emit(SyncingGroup(navIndex));
    _getGroupUseCase
        .launch(group.id)
        .then((value) => emit(GroupLoaded(navIndex)))
        .catchError((err) {
      showError(err);
    });
  }

  void showEvents() => showPage(GroupPageNav.events);

  void showServices() => showPage(GroupPageNav.services);

  void showDebt() => showPage(GroupPageNav.events);

  void showPage(GroupPageNav nav) {
    navIndex = nav;
    final newState = GroupLoaded(navIndex);
    emit(newState);
  }

  void showSettings() {
    showPage(GroupPageNav.settings);
  }

  void leaveGroup() {
    showLoading();
    _leaveGroupUseCase.launch(group.id).then((value) {
      emit(GroupLeft());
    }).catchError((err) {
      showError(err);
    });
  }

  void addPersonToGroup(Person person) {
    emit(AddingPersonToGroup());
    _addPersonToGroupUseCase.launch(group, person).then((value) {
      emit(Main());
    }).catchError((onError) {
      showError(onError);
    });
  }

  editGroupName(bool isEditing) {
    if (isEditing) {
      _updateEditGroupNameState(EditGroupNameState.isEditing);
    } else {
      _updateEditGroupNameState(EditGroupNameState.display);
    }
  }

  _updateEditGroupNameState(EditGroupNameState state) {
    editGroupNameState = state;
    emit(Main());
  }

  updateGroupName() {
    _updateEditGroupNameState(EditGroupNameState.isUpdating);
    _addGroupUseCase.launch(group).then((value) {
      _updateEditGroupNameState(EditGroupNameState.display);
    }).catchError((error) {
      _updateEditGroupNameState(EditGroupNameState.display);
    });
  }
}
