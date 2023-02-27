import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioConnectivityRequestRetrier {
   DioConnectivityRequestRetrier({
    @required this.dio,
    @required this.connectivity,
  });
  final Dio dio;
  final Connectivity connectivity;
  
  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    StreamSubscription streamSubscription;
    //responseCompleter!! to receive response from Dio,
    //because we are not on stream also it is void !!

    final responseCompleter = Completer<Response>();

    streamSubscription = connectivity.onConnectivityChanged.listen(
      (connectivityResult) {
        if (connectivityResult != ConnectivityResult.none) {
          //Cancel the stream, if it does the request then if
          //the conexion is does not change...we are not need
          //to do the request again.

          streamSubscription.cancel();
          responseCompleter.complete(
            dio.request(
              requestOptions.path,
              cancelToken: requestOptions.cancelToken,
              data: requestOptions.data,
              onReceiveProgress: requestOptions.onReceiveProgress,
              onSendProgress: requestOptions.onSendProgress,
              queryParameters: requestOptions.queryParameters,
              options: requestOptions,
            ),
          );
        }
      },
    );

    return responseCompleter.future;
  }
}
