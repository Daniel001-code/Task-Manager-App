import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_app/helper/database_helper.dart';
import 'package:notification_app/model/task_model.dart';
import 'package:notification_app/services/notification_service.dart';
import 'package:intl/intl.dart';

class TaskController extends GetxController {
  late Future<List<Task>> taskList;
  Future<void> addOrEditTask(
      {Task? task, required BuildContext context}) async {
    final titleController = TextEditingController(text: task?.title);
    final descriptionController =
        TextEditingController(text: task?.description);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(task == null ? 'Add Task' : 'Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text;
              final description = descriptionController.text;
              if (title.isNotEmpty && description.isNotEmpty) {
                if (task == null) {
                  // Create a new task
                  final newTask = Task(
                    title: title,
                    description: description,
                    createdTime: DateTime.now(),
                  );
                  int id = await DatabaseHelper.instance.createTask(newTask);
                  final insertedTask = newTask.copyWith(id: id);
                  refreshTaskList();
                  Navigator.of(context).pop();
                  await NotiService().showNotification(insertedTask);
                } else {
                  // Update an existing task
                  final updatedTask = Task(
                    id: task.id,
                    title: title,
                    description: description,
                    createdTime: task.createdTime,
                  );
                  refreshTaskList();
                  Navigator.of(context).pop();
                  await DatabaseHelper.instance.updateTask(updatedTask);
                }
              }
            },
            child: Text(task == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    refreshTaskList();
  }

  void refreshTaskList() {
    taskList = DatabaseHelper.instance.readAllTasks();
    update();
  }

  /// Formats the input datetime string and returns a date like "February 24".
  String formatDate(String dateTimeStr) {
    DateTime dt = DateTime.parse(dateTimeStr);
    // "MMMM" gives the full month name and "d" gives the day of the month.
    return DateFormat("MMMM d").format(dt);
  }

  /// Formats the input datetime string and returns a time like "7:00 PM".
  String formatTime(String dateTimeStr) {
    DateTime dt = DateTime.parse(dateTimeStr);
    // "h:mm a" gives the hour (1-12), minutes, and the AM/PM marker.
    return DateFormat("h:mm a").format(dt);
  }
}
