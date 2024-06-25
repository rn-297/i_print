class ToDoListClass {
  List<TodoList>? todoList;
  String? status;
  String? message;

  ToDoListClass({this.todoList, this.status, this.message});

  ToDoListClass.fromJson(Map<String, dynamic> json) {
    if (json['todo_list'] != null) {
      todoList = <TodoList>[];
      json['todo_list'].forEach((v) {
        todoList!.add(new TodoList.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.todoList != null) {
      data['todo_list'] = this.todoList!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class TodoList {
  String? todoMainImage;
  String? todoId;
  String? todoStatus;
  String? topImage;
  String? middleImage;
  String? bottomImage;

  TodoList(
      {this.todoMainImage,
        this.todoId,
        this.todoStatus,
        this.topImage,
        this.middleImage,
        this.bottomImage});

  TodoList.fromJson(Map<String, dynamic> json) {
    todoMainImage = json['todo_main_image'];
    todoId = json['todo_id'];
    todoStatus = json['todo_status'];
    topImage = json['top_image'];
    middleImage = json['middle_image'];
    bottomImage = json['bottom_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['todo_main_image'] = this.todoMainImage;
    data['todo_id'] = this.todoId;
    data['todo_status'] = this.todoStatus;
    data['top_image'] = this.topImage;
    data['middle_image'] = this.middleImage;
    data['bottom_image'] = this.bottomImage;
    return data;
  }
}
