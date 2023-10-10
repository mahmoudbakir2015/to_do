import 'package:flutter/material.dart';
import 'package:to_do/shared/cubit/to_do_cubit/cubit.dart';

Widget buildTaskItem({
  required int id,
  required String titleTask,
  required String dateTask,
  required String timeTask,
  required BuildContext context,
}) {
  return Dismissible(
    key: const Key("0"),
    onDismissed: (direction) {
      AppCubit.get(context).deleteFromDatabase(id: id);
    },
    child: Padding(
      padding: const EdgeInsets.all(
        20,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            child: Text(timeTask),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  titleTask,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  dateTask,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateDatabase(
                status: 'done',
                id: id,
              );
            },
            icon: const Icon(
              Icons.check_box,
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateDatabase(
                status: 'archived',
                id: id,
              );
            },
            icon: const Icon(
              Icons.archive,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    ),
  );
}
