import 'package:controleRetirada/domain/entities/event_entity.dart';

class EventDataSource {
  // ignore: missing_return
  Future<List<EventEntity>> getEvents(
    String companyId,
    String localId,
    String personId,
    String entityType,
    String departmentId,
    String loginId,
    String token,
  ) {}
}
