import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final getItSingleton = GetIt.instance;

Future<void> initializeDependencyInjectionContiner() async {
  getItSingleton.registerLazySingleton(() => InternetConnectionChecker());
}
