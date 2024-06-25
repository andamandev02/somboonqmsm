import './data.dart';
import 'package:json_annotation/json_annotation.dart';
part 'response_data.g.dart';

@JsonSerializable()
class ResponseData {
  bool? success;
  int? status;
  // String? message;
  Data? data;

  ResponseData({this.success, this.status, this.data});

  factory ResponseData.fromJson(Map<String, dynamic> json) =>
      _$ResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseDataToJson(this);
}
