class SubCategoryClass {
  List<SubCategories>? subCategories;
  String? status;
  String? message;

  SubCategoryClass({this.subCategories, this.status, this.message});

  SubCategoryClass.fromJson(Map<String, dynamic> json) {
    if (json['sub_categories'] != null) {
      subCategories = <SubCategories>[];
      json['sub_categories'].forEach((v) {
        subCategories!.add(SubCategories.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (subCategories != null) {
      data['sub_categories'] =
          subCategories!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['message'] = message;
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
        imageList!.add(ImageList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subcat_id'] = subcatId;
    data['subcat_name'] = subcatName;
    if (imageList != null) {
      data['image_list'] = imageList!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['print_count'] = printCount;
    data['subcat_img_url'] = subcatImgUrl;
    data['subcat_img_id'] = subcatImgId;
    return data;
  }
}
