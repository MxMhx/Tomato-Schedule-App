import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:tomato_schedule/configs/app_route.dart';
import 'package:tomato_schedule/configs/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomato_schedule/main.dart';
import 'package:tomato_schedule/model/task_model.dart';
import 'package:dio/dio.dart';
import 'package:tomato_schedule/model/user_model.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  static const routeName = '/addtask';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const AddTask(),
    );
  }

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final storage = const FlutterSecureStorage();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _collaborationController =
      TextEditingController();

  DateTime selectedDate = DateTime.now();

  String dateNow = DateFormat('y-M-d').format(DateTime.now()).toString();
  String startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String endTime = DateFormat("hh:mm a")
      .format(DateTime.now().add(const Duration(hours: 2)))
      .toString();

  int remind = 5;
  String repeat = 'none';

  List<int> remindList = [5, 10, 15, 20, 30];

  List<String> repeatList = ["none", "daily", "weekly", "monthly"];

  int selectedColor = 0xFF008BFF;

  List<int> colorList = [
    0xFF008BFF,
    0xFFE3EE03,
    0xFF07E500,
    0xFFFF0049,
  ];

  void createTask() async {
    final dio = Dio();
    final jsonString = await storage.read(key: userKey);
    if (jsonString != null) {
      final user = userFromJson(jsonString);
      List<String> collaboration = _collaborationController.text.split(',');
      await dio.post('http://localhost:6060/task/create-task', data: {
        "owner": user.username,
        "title": _nameController.text,
        "description": _descriptionController.text,
        "date": dateNow,
        "startTime": startTime,
        "endTime": endTime,
        "remind": remind,
        "repeat": repeat,
        "color": selectedColor.toString(),
        "status": "in-progress",
        "collaboration": collaboration
      });
    }
  }

  // void addTask(Task task) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<Task> taskList = [];

  //   String? jsonString = prefs.getString(taskKey);
  //   if (jsonString != null) {
  //     taskList = (jsonDecode(jsonString) as List)
  //         .map((taskMap) => Task.fromJson(taskMap))
  //         .toList();
  //   }
  //   taskList.add(task);
  //   String updatedJsonString =
  //       jsonEncode(taskList.map((task) => task.toJson()).toList());
  //   await prefs.setString(taskKey, updatedJsonString);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Task',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  inputBox(context, 'NAME', 'Task Name', _nameController),
                  inputBox(
                    context,
                    'Description',
                    'About task',
                    _descriptionController,
                  ),
                  inputBox(context, 'Collaboration', 'Ex. user1,user2',
                      _collaborationController)
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 5, right: 20, left: 20, bottom: 30),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 15, top: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(
                        dateNow,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          _getSelectDate();
                        },
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Time',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 15, top: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                title: Text(
                                  startTime,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.access_time_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End Time',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 15, top: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                title: Text(
                                  endTime,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.access_time_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Remind Me!!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 15, top: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(
                        '$remind minutes early',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      trailing: DropdownButton(
                        icon: const Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Colors.white,
                        ),
                        iconSize: 40,
                        items: remindList
                            .map<DropdownMenuItem<String>>(
                              (int value) => DropdownMenuItem(
                                value: value.toString(),
                                child: Text(
                                  value.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              remind = int.parse(value);
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  Text(
                    'Repeat',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 15, top: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(
                        repeat,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      trailing: DropdownButton(
                        icon: const Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Colors.white,
                        ),
                        iconSize: 40,
                        items: repeatList
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem(
                                value: value.toString(),
                                child: Text(
                                  value,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              repeat = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        spacing: 10,
                        children: List.generate(
                          colorList.length,
                          (index) => InkWell(
                            onTap: () {
                              setState(() {
                                selectedColor = colorList[index];
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: Color(colorList[index]),
                              radius: 15,
                              child: colorList[index] == selectedColor
                                  ? const Icon(
                                      Icons.check_sharp,
                                      color: Colors.white,
                                      size: 15,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          createTask();
                          // addTask(
                          //   Task(
                          //     name: _nameController.text,
                          //     description: _descriptionController.text,
                          //     date: DateFormat.yMd()
                          //         .format(selectedDate)
                          //         .toString(),
                          //     startTime: startTime,
                          //     endTime: endTime,
                          //     remind: remind,
                          //     repeat: repeat,
                          //     color: selectedColor,
                          //     status: 'Not Start',
                          //   ),
                          // );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NavBarView()),
                            (route) => false,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            'Create task',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Column inputBox(BuildContext context, String text, String hint,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 15, top: 5),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(15)),
          child: TextFormField(
            controller: controller,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: hint,
              labelStyle: Theme.of(context).textTheme.bodyLarge,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.grey),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  _getSelectDate() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (pickerDate != null) {
      setState(() {
        selectedDate = pickerDate;
        dateNow = DateFormat('y-M-d').format(pickerDate).toString();
      });
    }
  }
}
