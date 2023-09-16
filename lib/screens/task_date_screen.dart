import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomato_schedule/configs/config.dart';
import 'package:tomato_schedule/model/task_model.dart';
import 'package:tomato_schedule/model/user_model.dart';
import 'package:tomato_schedule/widget/widgets.dart';
import 'screens.dart';

class TaskDateScreen extends StatefulWidget {
  const TaskDateScreen({super.key});

  @override
  State<TaskDateScreen> createState() => _TaskDateScreenState();
}

class _TaskDateScreenState extends State<TaskDateScreen> {
  String selectedMonth = DateFormat.MMMM().format(DateTime.now());
  String selectedYear = DateFormat.y().format(DateTime.now());
  DateTime selectDate = DateTime.now();

  final storage = const FlutterSecureStorage();
  final dio = Dio();

  Future<List<Task>> getTaskList(DateTime selectDate) async {
    String selecteDateStr = DateFormat('y-M-d').format(selectDate);
    List<Task> taskList = [];
    final jsonString = await storage.read(key: userKey);
    if (jsonString != null) {
      final user = userFromJson(jsonString);
      Response res = await dio.get(
          'http://localhost:6060/task/by-date-and-owner/$selecteDateStr/${user.username}');
      List<dynamic> jsonStrTasks = res.data['tasks'];
      taskList = jsonStrTasks.map((e) => Task.fromJson(e)).toList();
      return taskList;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: const Icon(Icons.menu),
        actions: const [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: '$selectedMonth  ',
                        style: Theme.of(context).textTheme.displayMedium),
                    TextSpan(
                      text: selectedYear,
                      style:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                                color: Colors.grey.shade300,
                              ),
                    )
                  ])),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddTask(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        '+ Add task',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: DatePicker(
                DateTime.now(),
                height: 100,
                width: 80,
                initialSelectedDate: DateTime.now(),
                selectionColor: Theme.of(context).primaryColor,
                dayTextStyle: Theme.of(context).textTheme.bodyLarge!,
                dateTextStyle: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: Colors.grey.shade400),
                monthTextStyle: Theme.of(context).textTheme.bodyLarge!,
                onDateChange: (selectedDate) {
                  setState(() {
                    selectedMonth = DateFormat.MMMM().format(selectedDate);
                    selectedYear = DateFormat.y().format(selectedDate);
                    selectDate = selectedDate;
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: getTaskList(selectDate),
                  builder: (context, snapshot) {
                    final List<Task> taksList = snapshot.data ?? [];
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 15),
                      shrinkWrap: true,
                      itemCount: taksList.length,
                      itemBuilder: (context, index) {
                        return TaskEachDay(
                          task: taksList[index],
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
