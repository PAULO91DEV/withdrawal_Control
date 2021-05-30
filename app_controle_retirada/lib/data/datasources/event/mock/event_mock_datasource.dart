import 'package:controleRetirada/data/datasources/event/event_datasource.dart';
import 'package:controleRetirada/domain/entities/event_entity.dart';

class EventMockDataSource implements EventDataSource {
  @override
  Future<List<EventEntity>> getEvents(
    String companyId,
    String localId,
    String personId,
    String entityType,
    String departmentId,
    String loginId,
    String token,
  ) {
    return Future.delayed(Duration(seconds: 2)).then((_) {
      List<EventEntity> entities = <EventEntity>[];
      entities.add(EventEntity(
        companyId: "101",
        siteId: "MATRIZ-VA",
        eventId: "1",
        description: "Café da Manhã",
        // qtyMaximum: "3",
        pulloutSingle: 0,
        validFrom: "10/30/2020 12:00:00 AM",
        accumulative: 0,
      ));
      return entities;
    });
  }
}
