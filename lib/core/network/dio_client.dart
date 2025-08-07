import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../constants/app_constants.dart';
import '../services/logger_service.dart';
import '../services/storage_service.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio provideDio(DioClient dioClient) => dioClient.dio;
}

@lazySingleton
class DioClient {
  late final Dio _dio;
  final LoggerService _logger;
  final StorageService _storageService;

  DioClient(this._logger, this._storageService) {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    _setupInterceptors();
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final token = await _storageService.getSecureString(AppConstants.tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          _logger.info('Request: ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.info('CURL : ${response.requestOptions.method} ${response.requestOptions.path}');
          _logger.info('Response: ${response.statusCode} ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.error('Request Error: ${error.message}', error);
          handler.next(error);
        },
      ),
    );

    // Add logging interceptor in debug mode
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => _logger.debug(obj.toString()),
      ),
    );
  }
}
