
class IconsDataClass {
  List<IconsTabs>? tabs;
  String? status;
  String? message;

  IconsDataClass({this.tabs, this.status, this.message});

  IconsDataClass.fromJson(Map<String, dynamic> json) {
    if (json['tabs'] != null) {
      tabs = <IconsTabs>[];
      json['tabs'].forEach((v) {
        tabs!.add(new IconsTabs.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tabs != null) {
      data['tabs'] = this.tabs!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class IconsTabs {
  String? tabId;
  String? name;
  String? icon;
  List<String>? view;

  IconsTabs({this.tabId, this.name, this.icon, this.view});

  IconsTabs.fromJson(Map<String, dynamic> json) {
    tabId = json['tab_id'];
    name = json['name'];
    icon = json['icon'];
    view = json['view'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tab_id'] = this.tabId;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['view'] = this.view;
    return data;
  }
}
