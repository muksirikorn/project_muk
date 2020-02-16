import 'package:get_it/get_it.dart';
import 'package:project_muk/src/scoped_models/user.dart';
import 'package:project_muk/src/services/firebase_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<FirebaseServices>(() => FirebaseServices());

  locator.registerFactory<User>(() => User());
}
