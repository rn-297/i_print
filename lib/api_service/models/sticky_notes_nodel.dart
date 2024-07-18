class StickyNotesClass {
  List<StickyNotes>? stickyNotes;
  String? status;
  String? message;

  StickyNotesClass({this.stickyNotes, this.status, this.message});

  StickyNotesClass.fromJson(Map<String, dynamic> json) {
    if (json['sticky_notes'] != null) {
      stickyNotes = <StickyNotes>[];
      json['sticky_notes'].forEach((v) {
        stickyNotes!.add(StickyNotes.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (stickyNotes != null) {
      data['sticky_notes'] = stickyNotes!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['message'] = message;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stickynote_id'] = stickynoteId;
    data['stickynote_image'] = stickynoteImage;
    data['stickynote_status'] = stickynoteStatus;
    return data;
  }
}
