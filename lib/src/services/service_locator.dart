import 'package:get_it/get_it.dart';
import '../services/firebase_service.dart';
import '../scoped_models/user.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<FirebaseServices>(() => FirebaseServices());

  locator.registerFactory<User>(() => User());
}
