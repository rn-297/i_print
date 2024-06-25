class CategoryClass {
  List<Categories>? categories;
  String? status;
  String? message;

  CategoryClass({this.categories, this.status, this.message});

  CategoryClass.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Categories {
  String? catName;
  String? catId;
  List<SubCategories>? subCategories;

  Categories({this.catName, this.catId, this.subCategories});

  Categories.fromJson(Map<String, dynamic> json) {
    catName = json['cat_name'];
    catId = json['cat_id'];
    if (json['sub_categories'] != null) {
      subCategories = <SubCategories>[];
      json['sub_categories'].forEach((v) {
        subCategories!.add(new SubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cat_name'] = this.catName;
    data['cat_id'] = this.catId;
    if (this.subCategories != null) {
      data['sub_categories'] =
          this.subCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategories {
  String? subcatId;
  String? subcatName;

  SubCategories({this.subcatId, this.subcatName});

  SubCategories.fromJson(Map<String, dynamic> json) {
    subcatId = json['subcat_id'];
    subcatName = json['subcat_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subcat_id'] = this.subcatId;
    data['subcat_name'] = this.subcatName;
    return data;
  }
}
