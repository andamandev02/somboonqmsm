// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'response_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseData _$ResponseDataFromJson(Map<String, dynamic> json) {
  return ResponseData(
    success: json['success'] as bool,
    status: json['status'] as int,
    // message: json['message'] as String,
    data: Data.fromJson(json['data']),
  );
}

Map<String, dynamic> _$ResponseDataToJson(ResponseData instance) =>
    <String, dynamic>{
      'success': instance.success,
      'statusCode': instance.status,
      // 'message': instance.message,
      'data': instance.data,
    };
