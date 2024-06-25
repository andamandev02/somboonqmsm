import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  int? total;
  int? perPage;
  int? offset;
  int? to;
  int? lastPage;
  int? currentPage;
  int? pageCount;
  int? from;
  dynamic data;

  Data(
      {this.total,
      this.perPage,
      this.offset,
      this.to,
      this.lastPage,
      this.currentPage,
      this.pageCount,
      this.from,
      this.data});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}
