class BordersDataClass {
  List<BordersImages>? borders;
  String? status;
  String? message;

  BordersDataClass({this.borders, this.status, this.message});

  BordersDataClass.fromJson(Map<String, dynamic> json) {
    if (json['borders'] != null) {
      borders = <BordersImages>[];
      json['borders'].forEach((v) {
        borders!.add(new BordersImages.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.borders != null) {
      data['borders'] = this.borders!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class BordersImages {
  String? borderImage;
  String? type;

  BordersImages({this.borderImage, this.type});

  BordersImages.fromJson(Map<String, dynamic> json) {
    borderImage = json['border_image'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['border_image'] = this.borderImage;
    data['type'] = this.type;
    return data;
  }
}
