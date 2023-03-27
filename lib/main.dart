import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/layout/to_do_app/home_layout_to_do.dart';
import 'package:to_do/shared/cubit/to_do_cubit/cubit.dart';
import 'package:to_do/shared/cubit/to_do_cubit/states.dart';
import 'package:to_do/shared/network/local/cache_helper.dart';
import 'package:to_do/shared/network/remote/dio_helper.dart';
import 'shared/observer_block.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  DioHelper.init();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {

  const MyApp( {super.key});

  @override
  build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates state) {},
          builder: (BuildContext context, AppStates state) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: HomeLayoutToDo(),
            );
          }),
    );
  }
}
