// GENERATED CODE - DO NOT MODIFY BY HAND
part of './data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      total: json['total'] ?? 0,
      perPage: json['statusCode'] ?? 0,
      offset: json['offset'] ?? 0,
      to: json['to'] ?? 0,
      lastPage: json['lastPage'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      pageCount: json['pageCount'] ?? 0,
      from: json['from'] ?? 0,
      data: json['data']);
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'total': instance.total,
      'perPage': instance.perPage,
      'offset': instance.offset,
      'to': instance.to,
      'lastPage': instance.lastPage,
      'currentPage': instance.currentPage,
      'pageCount': instance.pageCount,
      'from': instance.from,
      'data': instance.data,
    };
