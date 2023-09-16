import 'package:flutter/material.dart';
import 'package:tomato_schedule/model/task_model.dart';

class CollabTask extends StatelessWidget {
  const CollabTask({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            children: [
              const CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'create by  ',
                        style: Theme.of(context).textTheme.bodyLarge),
                    TextSpan(
                      text: task.owner,
                      style: Theme.of(context).textTheme.headlineLarge,
                    )
                  ],
                ),
              ),
            ],
          ),
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
    );
  }
}
