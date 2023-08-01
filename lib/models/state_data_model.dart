import 'package:nest_matrimony/models/res_status_model.dart';

class StateDataModel extends ResStatusModel {
  List<StateData>? stateData;

  StateDataModel({this.stateData});

  StateDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      stateData = <StateData>[];
      json['data'].forEach((v) {
        stateData!.add(StateData.fromJson(v));
      });
    }
  }
}

class StateData {
  int? id;
  String? stateName;

  StateData({this.id, this.stateName});

  StateData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stateName = json['state_name'];
  }
}
