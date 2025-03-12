// -------------------------
// Main App Widget and UI: Task List Screen
// ------------------------

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_app/controller/task_controller.dart';
import 'package:notification_app/helper/database_helper.dart';

import '../model/task_model.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TaskController taskController = Get.find<TaskController>();
  late AnimationController _animeController;
  late Animation<double> _shakeAnimation;
  Timer? _shakeTimer;

  Timer? _inactivityTimer;
  static const int inactivityDuration = 60; // In seconds

  @override
  void initState() {
    super.initState();
    _startInactivityTimer();
    finalInit();
    // ✅ Initialize Animation Controller
    _animeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Shake duration
    );

    // ✅ Create Vibration Effect with TweenSequence
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1), // Left
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2), // Right
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 2), // Left
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2), // Right
      TweenSequenceItem(tween: Tween(begin: 10, end: 0), weight: 1), // Center
    ]).animate(_animeController);

    // ✅ Start Timer to Trigger Shake Every 15 Seconds
    _startShakeTimer();
  }

  void _startShakeTimer() {
    _shakeTimer?.cancel();
    _shakeTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _animeController.forward(from: 0); // Restart shake animation
    });
  }

  initializeTaskList() async {
    taskController.taskList = DatabaseHelper.instance.readAllTasks();
  }

  // ✅ Start inactivity timer
  void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: inactivityDuration), () {
      _showTipDialog();
    });
  }

  // ✅ Show tip dialog
  void _showTipDialog() {
    if (mounted) {
      Get.snackbar(
        backgroundColor: Colors.grey.withValues(alpha: 0.9),
        titleText: const Text(
          "Tip:",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: const Duration(seconds: 7),
        '',
        messageText: const Text(
          "Press + to create new task.\nSwipe from RIGHT to LEFT to delete a task.\nClick checkbox after completing task.",
          style: TextStyle(
            color: Colors.black45,
            fontWeight: FontWeight.bold,
          ),
        ),
        '',
      );
    }
  }

  // ✅ Reset timer on user interaction
  void _resetInactivityTimer() {
    _startInactivityTimer();
  }

  finalInit() async {
    await initializeTaskList();
    taskController.refreshTaskList();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    _shakeTimer?.cancel();
    _animeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rWidth = MediaQuery.of(context).size.width;
    final rHeight = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: const Text(
              'Task Manager',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            )),
        body: GetBuilder<TaskController>(builder: (taskController) {
          return GestureDetector(
              onTap: _resetInactivityTimer, // ✅ Detects taps
              onPanDown: (_) => _resetInactivityTimer(), // ✅ Detects swipes
              child: Stack(children: [
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

                                    return Dismissible(
                                      key: Key(tasks[index]
                                          .id
                                          .toString()), // Unique key for each task
                                      direction: DismissDirection
                                          .endToStart, // Swipe from right to left
                                      background: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: const Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                      // onDismissed: (direction) {
                                      //   taskController
                                      //       .deleteTask(tasks[index].id!);
                                      //   Get.snackbar("Deleted",
                                      //       "Task: '${tasks[index].title}...' was removed.");
                                      // },

                                      onDismissed: (direction) {
                                        if (index < tasks.length) {
                                          // ✅ Ensure index exists
                                          Task removedTask = tasks[
                                              index]; // ✅ Store task before removal
                                          taskController
                                              .deleteTask(tasks[index].id!);
                                          // ✅ Refresh UI

                                          // Optional: Show an Undo Snackbar
                                          Get.snackbar(
                                            backgroundColor: Colors.grey
                                                .withValues(alpha: 0.7),
                                            titleText: const Text(
                                              "Task Deleted",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            duration:
                                                const Duration(seconds: 3),
                                            '',
                                            messageText: Text(
                                              "You deleted: '${removedTask.title}'",
                                              style: const TextStyle(
                                                color: Colors.yellowAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            '',
                                            mainButton: TextButton(
                                              onPressed: () {
                                                taskController.undo(
                                                    task: removedTask,
                                                    context: context);
                                              },
                                              child: const Text(
                                                "Undo",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },

                                      child: Container(
                                        color: Colors.transparent,
                                        width: rWidth,
                                        padding: const EdgeInsets.only(
                                            right: 10, top: 5, bottom: 5),
                                        margin: EdgeInsets.only(
                                          top: 10,
                                          bottom: index == tasks.length - 1
                                              ? 100
                                              : 10,
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
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    month,
                                                    style: const TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            Color(0xFF6F6F6F)),
                                                  ),
                                                  // SizedBox(height: 10),
                                                  Text(
                                                    day,
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color:
                                                            Color(0xFF858585)),
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
                                                          ? const Color(
                                                              0xFFC54EDA)
                                                          : index == 1
                                                              ? const Color(
                                                                  0xFFF3B354)
                                                              : index == 2
                                                                  ? const Color(
                                                                      0xFF4FA8F0)
                                                                  : index == 3
                                                                      ? const Color(
                                                                          0xFFF85289)
                                                                      : index
                                                                              .isEven
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
                                                                      ? Colors
                                                                          .pink
                                                                      : index
                                                                              .isEven
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 4),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        tasks[index].isCompleted ==
                                                                false
                                                            ? const Text(
                                                                'Pending',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 10,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .fade,
                                                                ),
                                                              )
                                                            : const Text(
                                                                'Completed',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 10,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .fade,
                                                                ),
                                                              ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        InkWell(
                                                          onTap: tasks[index]
                                                                  .isCompleted
                                                              ? null
                                                              : () {
                                                                  taskController.setCompleted(
                                                                      task: tasks[
                                                                          index],
                                                                      context:
                                                                          context);
                                                                },
                                                          child: Container(
                                                            height: 15,
                                                            width: 15,
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: tasks[index]
                                                                            .isCompleted
                                                                        ? Colors
                                                                            .green
                                                                            .withValues(
                                                                                alpha:
                                                                                    0.7)
                                                                        : Colors
                                                                            .transparent,
                                                                    border: tasks[index]
                                                                            .isCompleted
                                                                        ? null
                                                                        : Border
                                                                            .all(
                                                                            color:
                                                                                Colors.red,
                                                                            width:
                                                                                2,
                                                                          )),
                                                            child: tasks[index]
                                                                    .isCompleted
                                                                ? const Icon(
                                                                    Icons.check,
                                                                    size: 12,
                                                                    color: Colors
                                                                        .white,
                                                                  )
                                                                : null,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5,
                                                        vertical: 2),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: Colors.white
                                                          .withValues(
                                                              alpha: 0.2),
                                                    ),
                                                    child: Text(
                                                      tasks[index].title,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    tasks[index].description,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow:
                                                          TextOverflow.fade,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10, top: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        InkWell(
                                                            onTap: () => taskController
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
                                                                        .circular(
                                                                            5),
                                                                color: Colors
                                                                    .white
                                                                    .withValues(
                                                                        alpha:
                                                                            0.2),
                                                              ),
                                                              child: const Icon(
                                                                Icons.edit,
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
                                      ),
                                    );
                                  });
                            }

                            return const Center(
                                child: Text('No Tasks. Click +'));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 40,
                    right: 20,
                    child: AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                                _shakeAnimation.value, 0), // Shake horizontally
                            child: ElevatedButton(
                                onPressed: () => taskController.addOrEditTask(
                                    context: context),
                                style: const ButtonStyle(
                                    padding:
                                        WidgetStatePropertyAll(EdgeInsets.zero),
                                    minimumSize:
                                        WidgetStatePropertyAll(Size(40, 40)),
                                    maximumSize:
                                        WidgetStatePropertyAll(Size(40, 40)),
                                    fixedSize:
                                        WidgetStatePropertyAll(Size(40, 40)),
                                    backgroundColor: WidgetStatePropertyAll(
                                        Color(0xFFB7BEC2))),
                                child: const Icon(Icons.add)),
                          );
                        })),
              ]));
        }));
  }
}
