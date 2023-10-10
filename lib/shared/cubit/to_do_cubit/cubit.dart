import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/modules/to_do_modules/archive_screen/archived_screen.dart';
import 'package:to_do/shared/cubit/to_do_cubit/states.dart';
import '../../../modules/to_do_modules/done_screen/done_screen.dart';
import '../../../modules/to_do_modules/tasks_screen/tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit()
      : super(
          AppInitialState(),
        );

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  bool isOpenSheet = false;
  IconData faIcon = Icons.edit;
  int currentPage = 0;
  Database? database;
  List<Map> newTasks = [];
  List id=[];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  List<Widget> screens = const [
    TaskScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];
  List<String> title = const [
    "Task Screen",
    "done Screen",
    "archived Screen",
  ];

  static AppCubit get(context) => BlocProvider.of(context);

  void changeIndex(int index) {
    currentPage = index;
    emit(
      AppChangeBottomNavBarState(),
    );
  }

  void createDatabaseMobile() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT, date TEXT,status TEXT,time TEXT)
        ''').then((value) {
          print("Database Created");
        }).catchError(
          (error) {
            print(
              "Error when creating table is ${error.toString()}",
            );
          },
        );
      },
      onOpen: (db) {
        getDataFromDatabase(db);
        print("database opened");
      },
    ).then((value) {
      database = value;
      emit(
        AppCreateDatabaseState(),
      );
    });
  }

  insertDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database?.transaction((txn) {
      return txn.rawInsert('''
    INSERT INTO tasks(title,date,time,status) VALUES ("$title","$date","$time","new")
    ''').then((value) {
        print("$value insert Successfully ");
        emit(
          AppInsertDatabaseState(),
        );

        getDataFromDatabase(database!);
      }).catchError((error) {
        print(
          "Error when inserting data is ${error.toString()}",
        );
      });
    });
  }

  void getDataFromDatabase(Database db) {
     id=[];
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(
      AppGetDatabaseLoadingState(),
    );
    db.rawQuery('''
  SELECT * FROM tasks
  ''').then((value) {
      for (var element in value) {
        print(element['status']);
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else if (element['status'] == 'archived') {
          archiveTasks.add(element);}
        id.add( element['id']);
        print(id);
      }

      newTasks = value;

      emit(
        AppGetDatabaseState(),
      );
    });
  }

  void changeStateOpenBottomSheet({
    required bool isShow,
    required IconData icon,
  }) {
    isOpenSheet = isShow;
    faIcon = icon;
    emit(
      AppChangeBottomSheetState(),
    );
  }

  void updateDatabase({required String status, required int id}) async {
    database!.rawUpdate(
      'UPDATE tasks SET status= ? WHERE id= ?',
      [status, id],
    ).then((value) {
      getDataFromDatabase(database!);
      emit(
        AppUpdateDatabaseState(),
      );
    });
  }

  void deleteFromDatabase({required int id}) async {
    database!.rawDelete(
      'DELETE FROM tasks WHERE id= ? ',
      [id],
    ).then((value) {
      getDataFromDatabase(database!);
      emit(
        AppDeleteFromDatabaseState(),
      );
    });
  }
}
