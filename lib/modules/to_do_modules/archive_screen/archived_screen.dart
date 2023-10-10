import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/cubit/to_do_cubit/cubit.dart';
import 'package:to_do/shared/cubit/to_do_cubit/states.dart';
import '../tasks_screen/components/components.dart';

class ArchivedScreen extends StatelessWidget {
  const ArchivedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        var tasks = AppCubit.get(context).archiveTasks;
        return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return buildTaskItem(
              id:AppCubit.get(context).id[index],
              titleTask: '${tasks[index]['title']}',
              dateTask: '${tasks[index]['date']}',
              timeTask: '${tasks[index]['time']}',
              context: context,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 20,
              ),
              child: Container(
                width: double.infinity,
                height: 2,
                color: Colors.grey[300],
              ),
            );
          },
          itemCount: tasks.length,
        );
      },
    );
  }
}
