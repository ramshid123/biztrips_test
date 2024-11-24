import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persons/features/persons/presentation/cubits/selected_filter_cubit.dart';
import 'package:persons/features/persons/presentation/person_bloc/persons_bloc.dart';
import 'package:persons/features/persons/presentation/view/view.dart';
import 'package:persons/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PersonsBloc>(create: (_) => serviceLocator()),
        BlocProvider<SelectedFilterCubit>(create: (_) => serviceLocator()),
      ],
      child: const MaterialApp(
        title: 'Name & Age',
        home: HomePage(),
      ),
    );
  }
}
