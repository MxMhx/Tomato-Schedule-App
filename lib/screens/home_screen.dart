import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomato_schedule/configs/config.dart';
import 'package:tomato_schedule/model/task_model.dart';
import 'package:tomato_schedule/model/user_model.dart';
import 'package:tomato_schedule/widget/task_card.dart';
import 'package:intl/intl.dart';
import 'package:tomato_schedule/widget/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const HomeScreen(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  Future<List<Task>> getCollaborationTask() async {
    List<Task> taskList = [];
    final jsonString = await storage.read(key: userKey);
    if (jsonString != null) {
      final user = userFromJson(jsonString);
      Response res = await dio
          .get('http://localhost:6060/task/by-collaborator/${user.username}');
      List<dynamic> jsonStrTasks = res.data['tasks'];
      taskList = jsonStrTasks.map((e) => Task.fromJson(e)).toList();
      return taskList;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMMd().format(DateTime.now()),
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Text(
                        '4 task today',
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    ],
                  ),
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              FutureBuilder(
                future: getTaskList(DateTime.now()),
                builder: (context, snapshot) {
                  final List<Task> taksList = snapshot.data ?? [];
                  if (taksList.isEmpty) return Container();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All today task',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.grey.shade400),
                      ),
                      SizedBox(
                        height: screenHeight * 0.27,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: taksList.length,
                          itemBuilder: (context, index) {
                            Task taskItem = taksList[index];
                            return TaskCard(
                              task: taskItem,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                  future: getCollaborationTask(),
                  builder: (context, snapshot) {
                    final List<Task> collabTaskList = snapshot.data ?? [];
                    if (collabTaskList.isEmpty) return Container();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'collaboration task',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.grey.shade400),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: collabTaskList.length,
                            itemBuilder: (context, index) {
                              return CollabTask(task: collabTaskList[index]);
                            }),
                      ],
                    );
                  })
            ],
          ),
        ),
      )),
    );
  }
}
