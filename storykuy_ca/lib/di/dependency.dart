import 'package:get_it/get_it.dart';
import 'package:storykuy/common/dio_service.dart';
import 'package:storykuy/data/authentication/datasource/auth_remote_datasource.dart';
import 'package:storykuy/data/authentication/mapper/auth_mapper.dart';
import 'package:storykuy/data/authentication/repository/auth_repository_impl.dart';
import 'package:storykuy/domain/repositories/auth_repository.dart';
import 'package:storykuy/presentation/authentication/provider/login_notifier.dart';

import '../domain/usecases/authentication/login_user_use_case.dart';

final locator = GetIt.instance;

void init() {
  _registerDomains();
}

void _registerDomains() {
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioService: locator()),
  );
  locator.registerLazySingleton<AuthMapper>(() => AuthMapper());
  locator.registerLazySingleton<AuthRepository>(() =>
      AuthRepositoryImpl(authRemoteDataSource: locator(), mapper: locator()));
  locator.registerLazySingleton<AuthRemoteDataSourceImpl>(
    () => AuthRemoteDataSourceImpl(dioService: locator()),
  );
  locator.registerLazySingleton<LoginUserUseCase>(
    () => LoginUserUseCase(authRepository: locator()),
  );
  locator.registerLazySingleton<LoginNotifier>(
    () => LoginNotifier(useCase: locator(), mapper: locator()),
  );
  locator.registerLazySingleton(() => DioService());
}
