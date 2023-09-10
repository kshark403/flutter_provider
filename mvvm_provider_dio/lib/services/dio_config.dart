import 'package:dio/dio.dart';
import 'package:mvvm_provider_dio/app.dart';
import 'package:mvvm_provider_dio/constants/network_api.dart';

class DioConfig {
  static final Dio _dio = Dio()
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['Content-Type'] = 'application/json';
        options.headers['Accept'] = 'application/json';
        options.baseUrl = NetworkAPI.baseURL;
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        switch(e.response?.statusCode){
          case 400:
            logger.e('Bad request');
            break;
          case 401:
            logger.e('Unauthorized');
            break;
          case 403:
            logger.e('Forbidden');
            break;
          case 404:
            logger.e('Not found');
            break;
          case 500:
            logger.e('Internal server error');
            break;
          default:
            logger.e('Something went wrong');
        }
        return handler.next(e);
      },
    ),
  );

  static Dio get dioInstance => _dio;
}