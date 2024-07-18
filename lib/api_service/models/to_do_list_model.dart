class ToDoListClass {
  List<TodoList>? todoList;
  String? status;
  String? message;

  ToDoListClass({this.todoList, this.status, this.message});

  ToDoListClass.fromJson(Map<String, dynamic> json) {
    if (json['todo_list'] != null) {
      todoList = <TodoList>[];
      json['todo_list'].forEach((v) {
        todoList!.add(TodoList.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (todoList != null) {
      data['todo_list'] = todoList!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['message'] = message;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['todo_main_image'] = todoMainImage;
    data['todo_id'] = todoId;
    data['todo_status'] = todoStatus;
    data['top_image'] = topImage;
    data['middle_image'] = middleImage;
    data['bottom_image'] = bottomImage;
    return data;
  }
}
