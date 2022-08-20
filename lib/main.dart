import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './firebase_options.dart';
import './repositories/database_repository.dart';
import './screens/homeScreen/home_screen.dart';
import './simple_bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = SimpleBlocObserver();
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  analytics.logAppOpen();
  runApp(MyApp(
    databaseRepository: DatabaseRepository(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(key: key);

  final DatabaseRepository _databaseRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => _databaseRepository,
        child: const MaterialApp(
          home: Home(),
        ));
  }
}
