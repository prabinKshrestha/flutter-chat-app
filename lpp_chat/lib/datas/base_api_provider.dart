import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lpp_chat/constants/app_constant.dart';

abstract class BaseAPIProvider {
  final Dio httpClient;

  BaseAPIProvider({@required this.httpClient}) {
    httpClient.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers.addAll({"Authorization": "Bearer ${AppConstant.JWT_TOKEN}"});
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  Future<T> getAction<T>(String path) async {
    return await _apiErrorHandler<T>(() async {
      final Response response = await this.httpClient.get<T>(_buildURI(path));
      return response.data;
    });
  }

  Future<T> postAction<T>(String path, Map<String, dynamic> body, [bool isFormData = false]) async {
    return await _apiErrorHandler<T>(() async {
      final Response response = await this.httpClient.post<T>(_buildURI(path), data: isFormData ? FormData.fromMap(body) : body);
      return response.data;
    });
  }

  Future<T> putAction<T>(String path, Map<String, dynamic> body) async {
    return await _apiErrorHandler<T>(() async {
      final Response response = await this.httpClient.put<T>(_buildURI(path), data: body);
      return response.data;
    });
  }

  Future<void> deleteAction(String path) async {
    return await _apiErrorHandler(() async => await this.httpClient.delete(_buildURI(path)));
  }

  String _buildURI(String path) {
    return "${AppConstant.TOTAL_BASE_URL}/api/v1/$path";
  }

  Future<T> _apiErrorHandler<T>(Function function) async {
    try {
      return await function();
    } on DioError catch (e) {
      // handle error here
      return Future.value();
    }
  }
}
