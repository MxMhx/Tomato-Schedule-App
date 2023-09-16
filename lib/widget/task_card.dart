import 'package:flutter/material.dart';
import 'package:tomato_schedule/model/task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 15, top: 15),
        padding: const EdgeInsets.all(20),
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
            const Spacer(),
            taskAttribute(
                context, Icons.timer, '${task.startTime} - ${task.endTime}'),
            const SizedBox(
              height: 10,
            ),
            taskAttribute(context, Icons.task_alt_rounded, task.status),
            const SizedBox(
              height: 10,
            ),
            taskAttribute(context, Icons.notification_add_rounded, task.repeat),
          ],
        ),
      ),
    );
  }

  Widget taskAttribute(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
