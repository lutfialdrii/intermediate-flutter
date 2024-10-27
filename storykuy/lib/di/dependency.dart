import 'package:get_it/get_it.dart';
import 'package:storykuy/common/dio_service.dart';
import 'package:storykuy/data/authentication/datasource/auth_remote_datasource.dart';

final locator = GetIt.instance;

void init() {
  _registerDomains();
}

void _registerDomains() {
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioService: locator()),
  );
  locator.registerLazySingleton(() => DioService());
}
