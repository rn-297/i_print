class SubCategoryClass {
  List<SubCategories>? subCategories;
  String? status;
  String? message;

  SubCategoryClass({this.subCategories, this.status, this.message});

  SubCategoryClass.fromJson(Map<String, dynamic> json) {
    if (json['sub_categories'] != null) {
      subCategories = <SubCategories>[];
      json['sub_categories'].forEach((v) {
        subCategories!.add(new SubCategories.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subCategories != null) {
      data['sub_categories'] =
          this.subCategories!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class SubCategories {
  String? subcatId;
  String? subcatName;
  List<ImageList>? imageList;

  SubCategories({this.subcatId, this.subcatName, this.imageList});

  SubCategories.fromJson(Map<String, dynamic> json) {
    subcatId = json['subcat_id'];
    subcatName = json['subcat_name'];
    if (json['image_list'] != null) {
      imageList = <ImageList>[];
      json['image_list'].forEach((v) {
        imageList!.add(new ImageList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subcat_id'] = this.subcatId;
    data['subcat_name'] = this.subcatName;
    if (this.imageList != null) {
      data['image_list'] = this.imageList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageList {
  String? printCount;
  String? subcatImgUrl;
  String? subcatImgId;

  ImageList({this.printCount, this.subcatImgUrl, this.subcatImgId});

  ImageList.fromJson(Map<String, dynamic> json) {
    printCount = json['print_count'];
    subcatImgUrl = json['subcat_img_url'];
    subcatImgId = json['subcat_img_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['print_count'] = this.printCount;
    data['subcat_img_url'] = this.subcatImgUrl;
    data['subcat_img_id'] = this.subcatImgId;
    return data;
  }
}
