import 'package:billsplit_flutter/domain/models/event.dart';
import 'package:billsplit_flutter/domain/models/person.dart';

class Group {
  final String id;
  final String _name;
  final String _coverImageUrl;
  final List<Person> people;
  final List<Person> pastMembers;
  final List<Person> invites;
  final Person createdBy;
  final num timestamp;
  final Event? _latestEvent;
  final int _lastUpdated;
  final String _defaultCurrency;

  // modifiable values
  late String nameState = _name;
  late int lastUpdatedState = _lastUpdated;
  late Event? latestEventState = _latestEvent;
  late String defaultCurrencyState = _defaultCurrency;
  late String coverImageUrlState = _coverImageUrl;

  Group(
      {required this.id,
      required String name,
      required String coverImageUrl,
      required this.people,
      required this.pastMembers,
      required this.invites,
      required this.createdBy,
      required this.timestamp,
      required int lastUpdated,
      required Event? latestEvent,
      required String defaultCurrency})
      : _latestEvent = latestEvent,
        _name = name,
        _lastUpdated = lastUpdated,
        _coverImageUrl = coverImageUrl,
        _defaultCurrency = defaultCurrency;

  Iterable<Person> get allPeople => [...people, ...pastMembers];

  void respondToInvite(Person user, bool accept) {
    invites.remove(user);
    if (accept) {
      people.add(user);
    }
  }

  void invitePerson(Person person){
    invites.add(person);
  }

  Group.newGroup(
      Person createdBy, String name, List<Person> people, String currency)
      : this(
          id: "",
          createdBy: createdBy,
          coverImageUrl: "",
          name: name,
          people: [createdBy],
          pastMembers: [],
          invites: people,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          lastUpdated: DateTime.now().millisecondsSinceEpoch,
          latestEvent: null,
          defaultCurrency: currency,
        );

  Group.mock(num seed)
      : this(
          id: "G$seed",
          name: "Group $seed",
          coverImageUrl: "",
          pastMembers: [],
          people: [],
          invites: [],
          createdBy: Person.dummy(2),
          timestamp: 0,
          lastUpdated: 0,
          defaultCurrency: "usd",
          latestEvent: null,
        );

  void reset() {
    nameState = _name;
    latestEventState = _latestEvent;
  }
}
