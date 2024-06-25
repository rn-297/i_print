class StickyNotesClass {
  List<StickyNotes>? stickyNotes;
  String? status;
  String? message;

  StickyNotesClass({this.stickyNotes, this.status, this.message});

  StickyNotesClass.fromJson(Map<String, dynamic> json) {
    if (json['sticky_notes'] != null) {
      stickyNotes = <StickyNotes>[];
      json['sticky_notes'].forEach((v) {
        stickyNotes!.add(new StickyNotes.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stickyNotes != null) {
      data['sticky_notes'] = this.stickyNotes!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class StickyNotes {
  String? stickynoteId;
  String? stickynoteImage;
  String? stickynoteStatus;

  StickyNotes({this.stickynoteId, this.stickynoteImage, this.stickynoteStatus});

  StickyNotes.fromJson(Map<String, dynamic> json) {
    stickynoteId = json['stickynote_id'];
    stickynoteImage = json['stickynote_image'];
    stickynoteStatus = json['stickynote_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stickynote_id'] = this.stickynoteId;
    data['stickynote_image'] = this.stickynoteImage;
    data['stickynote_status'] = this.stickynoteStatus;
    return data;
  }
}
