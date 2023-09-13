import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 15, top: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.pink,
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
                          text: 'Physic\n',
                          style: Theme.of(context).textTheme.displaySmall),
                      TextSpan(
                        text: 'Chapter 3 : I dont',
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
            taskAttribute(context, Icons.timer, '09:30 - 12:30'),
            const SizedBox(
              height: 10,
            ),
            taskAttribute(context, Icons.task_alt_rounded, 'in progess'),
            const SizedBox(
              height: 10,
            ),
            taskAttribute(context, Icons.place, 'KMITL A Room'),
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
