import 'package:flutter/material.dart';
import 'package:tomato_schedule/model/task_model.dart';

class TaskEachDay extends StatelessWidget {
  const TaskEachDay({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          task.startTime,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Container(
          width: 280,
          margin: const EdgeInsets.only(right: 15, top: 15),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Color(int.parse(task.color)),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: '${task.title}\n',
                            style: Theme.of(context).textTheme.displaySmall),
                        TextSpan(
                          text: task.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.topRight,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.task_alt_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    task.status,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
