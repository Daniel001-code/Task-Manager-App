// -------------------------
// Main App Widget and UI: Task List Screen
// ------------------------

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_app/controller/task_controller.dart';

import '../model/task_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TaskController taskController = Get.find<TaskController>();
  @override
  void initState() {
    super.initState();
    taskController.refreshTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(builder: (taskController) {
      final rWidth = MediaQuery.of(context).size.width;
      final rHeight = MediaQuery.of(context).size.width;
      return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Task Manager',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            )),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, Smith',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Have a nice day!',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD0CFCF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.black87,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'My Task',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xA9000000)),
                  ),
                  Expanded(
                    child: FutureBuilder<List<Task>>(
                      future: taskController.taskList,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasData) {
                          final tasks = snapshot.data!;

                          return ListView.builder(
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                String month = taskController.formatDate(
                                    tasks[index].createdTime.toString());
                                String day = taskController.formatTime(
                                    tasks[index].createdTime.toString());

                                return Container(
                                  // height: rHeight * 0.26,
                                  width: rWidth,
                                  padding: const EdgeInsets.only(
                                      right: 10, top: 5, bottom: 5),
                                  margin: EdgeInsets.only(
                                    top: 10,
                                    bottom:
                                        index == tasks.length - 1 ? 100 : 10,
                                    left: 5,
                                    right: 5,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: rWidth * 0.16,
                                        height: rHeight * 0.21,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              month,
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFF6F6F6F)),
                                            ),
                                            // SizedBox(height: 10),
                                            Text(
                                              day,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF858585)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: rWidth * 0.71,
                                        // height: rHeight * 0.2,
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                index == 0
                                                    ? const Color(0xFFC54EDA)
                                                    : index == 1
                                                        ? const Color(
                                                            0xFFF3B354)
                                                        : index == 2
                                                            ? const Color(
                                                                0xFF4FA8F0)
                                                            : index == 3
                                                                ? const Color(
                                                                    0xFFF85289)
                                                                : index.isEven
                                                                    ? const Color(
                                                                        0xFFC23ADB)
                                                                    : const Color(
                                                                        0xFF6B7FF1),
                                                index == 0
                                                    ? Colors.purple
                                                    : index == 1
                                                        ? Colors.orange
                                                        : index == 2
                                                            ? Colors.blue
                                                            : index == 3
                                                                ? Colors.pink
                                                                : index.isEven
                                                                    ? Colors
                                                                        .purple
                                                                    : Colors
                                                                        .indigo,
                                              ]),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),

                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.white
                                                    .withValues(alpha: 0.2),
                                              ),
                                              child: Text(
                                                tasks[index].title,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  overflow: TextOverflow.fade,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              tasks[index].description,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.fade,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10, top: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                      onTap: () =>
                                                          taskController
                                                              .addOrEditTask(
                                                                  task: tasks[
                                                                      index],
                                                                  context:
                                                                      context),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Colors.white
                                                              .withValues(
                                                                  alpha: 0.2),
                                                        ),
                                                        child: const Icon(
                                                          Icons.edit,
                                                          size: 17,
                                                        ),
                                                      )),
                                                  const SizedBox(width: 15),
                                                  InkWell(
                                                      onTap: () =>
                                                          taskController
                                                              .deleteTask(
                                                                  tasks[index]
                                                                      .id!),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Colors.white
                                                              .withValues(
                                                                  alpha: 0.2),
                                                        ),
                                                        child: const Icon(
                                                          Icons.delete,
                                                          size: 17,
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        }
                        return const Center(child: Text('No Tasks'));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 40,
              right: 20,
              child: ElevatedButton(
                  onPressed: () =>
                      taskController.addOrEditTask(context: context),
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Color.fromARGB(255, 183, 190, 194))),
                  child: const Icon(Icons.add)),
            )
          ],
        ),
      );
    });
  }
}
