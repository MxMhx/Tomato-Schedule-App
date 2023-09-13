import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class TaskDateScreen extends StatefulWidget {
  const TaskDateScreen({super.key});

  @override
  State<TaskDateScreen> createState() => _TaskDateScreenState();
}

class _TaskDateScreenState extends State<TaskDateScreen> {
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Row(
                  children: [
                    const Spacer(),
                    Container(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
