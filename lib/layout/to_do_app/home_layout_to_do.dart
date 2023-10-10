import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/cubit/to_do_cubit/cubit.dart';
import 'package:to_do/shared/cubit/to_do_cubit/states.dart';
import '../../shared/components/componnents_to_do/components.dart';

class HomeLayoutToDo extends StatelessWidget {
  const HomeLayoutToDo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabaseMobile(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.of(context).pop();
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: cubit.scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.title[cubit.currentPage],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                cubit.changeIndex(index);
              },
              currentIndex: cubit.currentPage,
              items: const [
                BottomNavigationBarItem(
                  label: 'tasks',
                  icon: Icon(
                    Icons.task,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'done',
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'archive',
                  icon: Icon(
                    Icons.archive,
                  ),
                ),
              ],
            ),
            body: cubit.screens[cubit.currentPage],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                cubit.changeStateOpenBottomSheet(
                  isShow: true,
                  icon: Icons.add,
                );
                if (cubit.isOpenSheet) {
                  cubit.scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) {
                          return Form(
                            key: cubit.formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextForm(
                                  label: 'Task title',
                                  controller: cubit.titleController,
                                  textInputType: TextInputType.text,
                                  iconData: Icons.add,
                                  onValidate: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Task title must be not empty ";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                defaultTextForm(
                                  readonly: true,
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then(
                                      (value) {
                                        cubit.timeController.text =
                                            value!.format(context);
                                      },
                                    );
                                  },
                                  label: 'Task time',
                                  controller: cubit.timeController,
                                  textInputType: TextInputType.datetime,
                                  iconData: Icons.access_time,
                                  onValidate: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Task time must be not empty ";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                defaultTextForm(
                                  readonly: true,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2030),
                                    ).then(
                                      (value) {
                                        cubit.dateController.text =
                                            "${value!.day}/${value.month}/${value.year}";
                                      },
                                    );
                                  },
                                  label: 'Task date',
                                  controller: cubit.dateController,
                                  textInputType: TextInputType.datetime,
                                  iconData: Icons.date_range,
                                  onValidate: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Task date must be not empty ";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        },
                      )
                      .closed
                      .then(
                        (value) async{
                           cubit.changeStateOpenBottomSheet(
                            isShow: false,
                            icon: Icons.edit,
                          );
                        },
                      );
                }
                if (cubit.formKey.currentState!.validate()) {
                  cubit.insertDatabase(
                    title: cubit.titleController.text,
                    date: cubit.dateController.text,
                    time: cubit.timeController.text,
                  );

                }
              },

              child: Icon(
                cubit.faIcon,
              ),
            ),
          );
        },
      ),
    );
  }
}
