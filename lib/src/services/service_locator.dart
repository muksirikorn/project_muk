import 'package:get_it/get_it.dart';
import '../services/firebase_service.dart';
import '../scoped_models/user.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // Register services
  locator.registerLazySingleton<FirebaseServices>(() => FirebaseServices());

  // Register models
  locator.registerFactory<User>(() => User());
}
