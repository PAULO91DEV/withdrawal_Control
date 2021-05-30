import 'package:dio/dio.dart';
import 'package:controleRetirada/commons/constants.dart';
import 'package:controleRetirada/data/datasources/event/event_datasource.dart';
import 'package:controleRetirada/domain/entities/event_entity.dart';

class EventRemoteDataSource implements EventDataSource {
  final Dio _dio;
  EventRemoteDataSource(this._dio);

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
    return this._dio.get(
      "$kUrlEvents/api/event",
      queryParameters: {
        'get_companyId': companyId,
        'localId': localId,
        'personId': personId,
        'entityType': entityType,
        'departmentId': departmentId,
        'loginId': loginId,
        'tokenAPI': token,
      },
    ).then((result) {
      List<EventEntity> entities = <EventEntity>[];

      if (result.data != null) {
        entities =
            (result.data as List).map((x) => EventEntity.fromJson(x)).toList();
      }
      return entities;
    });
  }
}
