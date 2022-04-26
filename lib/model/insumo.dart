import 'package:hive/hive.dart';
part 'insumo.g.dart';

@HiveType(typeId: 0)
class Insumo {
  @HiveField(0)
  String? product;
  @HiveField(1)
  String? value;
  @HiveField(2)
  String? mesureType;
  @HiveField(3)
  String? inputDate;
  @HiveField(4)
  String? observation;
  @HiveField(5)
  String? status;

  Insumo(
      {this.product,
      this.value,
      this.mesureType,
      this.inputDate,
      this.observation,
      this.status});

  Insumo.fromJson(Map<String, dynamic> json) {
    product = json['product'];
    value = json['value'];
    mesureType = json['mesureType'];
    inputDate = json['inputDate'];
    observation = json['Observation'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product'] = product;
    data['value'] = value;
    data['mesureType'] = mesureType;
    data['inputDate'] = inputDate;
    data['Observation'] = observation;
    data['Status'] = status;
    return data;
  }
}