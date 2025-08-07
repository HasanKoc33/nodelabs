// Comprehensive test suite for the Nodelabs Movie Discovery App
// This file imports and runs all unit tests for the application

import 'package:flutter_test/flutter_test.dart';

// Core tests
import 'core/services/storage_service_test.dart' as storage_service_test;
import 'core/services/logger_service_test.dart' as logger_service_test;
import 'core/network/dio_client_test.dart' as dio_client_test;
import 'core/network/network_info_test.dart' as network_info_test;

// Data layer tests
import 'data/models/user_model_test.dart' as user_model_test;
import 'data/models/auth_model_test.dart' as auth_model_test;
import 'data/models/movie_model_test.dart' as movie_model_test;
import 'data/datasources/remote/auth_remote_datasource_test.dart' as auth_remote_datasource_test;
import 'data/repositories/auth_repository_impl_test.dart' as auth_repository_impl_test;

// Domain layer tests
import 'domain/usecases/auth/login_usecase_test.dart' as login_usecase_test;

// Presentation layer tests
import 'presentation/bloc/auth/auth_bloc_test.dart' as auth_bloc_test;

void main() {
  group('Nodelabs Movie Discovery App Tests', () {
    group('Core Layer Tests', () {
      group('Services', () {
        storage_service_test.main();
        logger_service_test.main();
      });
      
      group('Network', () {
        dio_client_test.main();
      });
    });

    group('Data Layer Tests', () {
      group('Models', () {
        user_model_test.main();
        auth_model_test.main();
        movie_model_test.main();
      });
      
      group('DataSources', () {
        auth_remote_datasource_test.main();
      });
      
      group('Repositories', () {
        auth_repository_impl_test.main();
      });
    });

    group('Domain Layer Tests', () {
      group('UseCases', () {
        login_usecase_test.main();
      });
    });

    group('Presentation Layer Tests', () {
      group('BLoC', () {
        auth_bloc_test.main();
      });
    });
  });
}
