import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:grocery_store/models/customer.dart';
import 'package:grocery_store/util/config.dart';
import 'package:woocommerce_api/woocommerce_api.dart';
import 'package:http/http.dart' as http;

class APIService {
  Future<bool> createCustomerData(CustomerModel customer) async {
    bool ret = false;

    try {
      http.Response response = await http.post(
        Uri.parse(
            "${Config.url}${Config.customerURL}?consumer_key=${Config.key}&consumer_secret=${Config.secret}"),
        body: customer.toJson(),
      );

      ret = true;
    } catch (e) {
      log(e.toString());
      ret = false;
    }

    return ret;
  }

  Future getCustomerDetails() async {
    var url = Uri.parse(
        "${Config.url}${Config.customerURL}?consumer_key=${Config.key}&consumer_secret=${Config.secret}");
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      log("Works");
      String data = response.body;
      var decodedData = jsonDecode(data);
      log(decodedData[1].toString());
      return decodedData;
    } else {
      log("Doesn't work");
    }
  }
}


/*
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
*/