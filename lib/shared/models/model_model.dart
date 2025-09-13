class ModelModel {
  int? modelId;
  String? modelName;

  ModelModel({this.modelId, this.modelName});

  ModelModel.fromJson(Map<String, dynamic> json) {
    modelId = json['model_id'];
    modelName = json['model_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['model_id'] = modelId;
    data['model_name'] = modelName;
    return data;
  }
}
