import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';

import 'dio/dio_connectivity_request_retrier.dart';
import 'dio/retry_interceptor.dart';

class ApiClient {
  Dio dio = Dio();
  Connectivity connectivity;
  static const String baseUrl = 'https://www.metaweather.com';

  ApiClient init() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
    ));
    dio.interceptors.add(LogInterceptor(
      responseHeader: false,
    ));
    RetryOnConnectionChangeInterceptor(
      requestRetrier: DioConnectivityRequestRetrier(
        dio: dio,
        connectivity: Connectivity(),
      ),
    );

    return this;
  }
}
