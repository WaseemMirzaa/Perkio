// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:nb_utils/nb_utils.dart';

class DioHelper {
  static String baseURL = "https://us-central1-linker-6bfd6.cloudfunctions.net/";
  static String apiErrorResponse = "Something went wrong! Please try again";

  static const ERROR = "error";
  static const SUCCESS = "success";




  static String getJsonString(Map<String,dynamic> map){
    Map<String, dynamic> castedMap = {};
    map.forEach((key, value) {
      castedMap[key.toString()] = value;
    });

    return jsonEncode(castedMap);
  }

  //========GET========

  static Future<ApiResponse> get(String url) async {
    var dio = Dio();
    try {
      final response = await dio.get(
        url,
      );
      if (response.data != null && response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202 ||
          response.statusCode == 203 ||
          response.statusCode == 204 ||
          response.statusCode == 205) {
        var jsonString = json.encode(response.data);
        return ApiResponse(jsonString, true);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // log("$kDebugug ${e.message} $kDebug");
      }
    }
    return ApiResponse(null, false);
  }

  //========POST========

  // static Future<ApiResponse> post(String url, Map<String, dynamic> map) async {
  static Future<ApiResponse> post(String url, String jsonString) async {
    var dio = Dio();
    try {
      final response = await dio.post(url,
          data: jsonString,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "text/plain",
          }));

      // log("response:$kDebug $response $kDebug");
      if (response.data != null && response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202 ||
          response.statusCode == 203 ||
          response.statusCode == 204 ||
          response.statusCode == 205) {
        var jsonString = json.encode(response.data);
        return ApiResponse(jsonString, true);
      } else{
        if (kDebugMode) {
          print("error: " + response.data ?? "");
        }
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // log("$kDebug ${e.message} $kDebug");
      }
    }
    return ApiResponse(null, false);
  }

//========PATCH========

  static Future<ApiResponse> patch(String url, String jsonString) async {
    var dio = Dio();
    try {
      final response = await dio.patch(url,
          data: jsonString,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      log("response: $response");
      if (response.data != null && response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202 ||
          response.statusCode == 203 ||
          response.statusCode == 204 ||
          response.statusCode == 205) {
        var jsonString = json.encode(response.data);
        return ApiResponse(jsonString, true);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // log("$kDebug ${e.message} $kDebug");
      }
    }
    return ApiResponse(null, false);
  }

  //=======DELETE=======

  static Future<ApiResponse> delete(String url) async {
    var dio = Dio();
    try {
      final response = await dio.delete(
        url,
      );

      log("response: $response");
      if (response.data != null && response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202 ||
          response.statusCode == 203 ||
          response.statusCode == 204 ||
          response.statusCode == 205) {
        var jsonString = json.encode(response.data);
        return ApiResponse(jsonString, true);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // log("$kDebug ${e.message} $kDebug");
      }
    }
    return ApiResponse(null, false);
  }
}

class ApiResponse {
  dynamic body;
  bool isSuccess;

  ApiResponse(this.body, this.isSuccess);
}