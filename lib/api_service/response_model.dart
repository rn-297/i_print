class ResponseModel {
  String? image;
  String? finishReason;
  int? seed;

  ResponseModel({this.image, this.finishReason, this.seed});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    finishReason = json['finish_reason'];
    seed = json['seed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['finish_reason'] = finishReason;
    data['seed'] = seed;
    return data;
  }
}
