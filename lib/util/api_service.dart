import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:grocery_store/models/customer.dart';
import 'package:grocery_store/util/config.dart';

class APIService {
  Future<bool> createCustomer(CustomerModel customer) async {
    var authToken = base64.encode(
      utf8.encode("${Config.key}:${Config.secret}"),
    );

    bool ret = false;

    try {
      var response = await Dio().post(
        Config.url + Config.customerURL,
        data: customer.toJson(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: 'application/json'
          },
        ),
      );

      if (response.statusCode == 201) {
        ret = true;
      }
    } on DioError catch (e) {
      log(e.toString());
      if (e.response?.statusCode == 401) {
        log("Exists");
        ret = false;
      } else {
        ret = false;
      }
    }

    return ret;
  }
}
