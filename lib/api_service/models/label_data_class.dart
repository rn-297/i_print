class LabelDataClass {
  List<LabelImages>? images;
  String? status;
  String? message;

  LabelDataClass({this.images, this.status, this.message});

  LabelDataClass.fromJson(Map<String, dynamic> json) {
    if (json['images'] != null) {
      images = <LabelImages>[];
      json['images'].forEach((v) {
        images!.add(new LabelImages.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class LabelImages {
  String? url;
  String? icon;
  String? borderPosition;
  String? borderImageUrl;
  String? text;

  LabelImages(
      {this.url,
        this.icon,
        this.borderPosition,
        this.borderImageUrl,
        this.text});

  LabelImages.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    icon = json['icon'];
    borderPosition = json['borderPosition'];
    borderImageUrl = json['borderImageUrl'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['icon'] = this.icon;
    data['borderPosition'] = this.borderPosition;
    data['borderImageUrl'] = this.borderImageUrl;
    data['text'] = this.text;
    return data;
  }
}
