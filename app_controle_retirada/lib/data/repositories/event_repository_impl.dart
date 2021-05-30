import 'package:controleRetirada/data/datasources/event/event_datasource.dart';
import 'package:controleRetirada/domain/entities/event_entity.dart';
import 'package:controleRetirada/domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventDataSource _dataSource;
  EventRepositoryImpl(this._dataSource);

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
    return this._dataSource.getEvents(
          companyId,
          localId,
          personId,
          entityType,
          departmentId,
          loginId,
          token,
        );
  }
}
