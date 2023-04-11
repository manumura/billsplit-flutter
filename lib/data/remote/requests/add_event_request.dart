import 'package:billsplit_flutter/data/remote/dtos/debts_dto.dart';
import 'package:billsplit_flutter/data/remote/dtos/event_dto.dart';
import 'package:billsplit_flutter/extensions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_event_request.g.dart';

@JsonSerializable(createFactory: false)
class AddEventRequest {
  final String groupId;
  final EventDTO event;
  final List<DebtDTO> debts;

  AddEventRequest(this.groupId, this.event, this.debts);

  Json toJson() => _$AddEventRequestToJson(this);

}

@JsonSerializable(createToJson: false)
class AddEventResponse {
  final EventDTO? event;

  AddEventResponse(this.event);

  factory AddEventResponse.fromJson(Json json) => _$AddEventResponseFromJson(json);
}

/**
 * object AddEvent {

    @kotlinx.serialization.Serializable
    data class Request(
    val groupId: String,
    val event: EventDTO,
    val debts: List<DebtDTO>
    )

    @kotlinx.serialization.Serializable
    data class Response(
    val event: EventDTO
    )
    }
 */