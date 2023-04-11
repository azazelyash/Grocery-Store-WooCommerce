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
    var authToken = base64.encode(
      utf8.encode("${Config.key}:${Config.secret}"),
    );

    try {
      http.Response response = await http.post(
        Uri.parse(
            "${Config.url}${Config.customerURL}?consumer_key=${Config.key}&consumer_secret=${Config.secret}"),
        body: customer.toJson(),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic $authToken',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
      );
      var data = jsonDecode(response.body);
      log(data.toString());

      ret = true;
    } catch (e) {
      log(e.toString());
      ret = false;
    }

    return ret;
  }

  // Future<void> createCustomer() async {
  //   final url = Uri.parse(
  //       'https://grocerystore.skygoaltech.com//wp-json/wc/v3/customers?consumer_key=ck_c6104bbac4a739e08e6e56ecd72c60218ad8012c&consumer_secret=cs_7662eca8cf33f288a8e94f0c12ac9004c9d7f507&email=test123@example.com');
  //   final consumerKey = 'ck_c6104bbac4a739e08e6e56ecd72c60218ad8012c';
  //   final consumerSecret = 'cs_7662eca8cf33f288a8e94f0c12ac9004c9d7f507';

  //   final response = await http.post(
  //     url,
  //     // headers: {
  //     //   'Content-Type': 'application/json',
  //     //   'Authorization': 'Basic ' +
  //     //       base64Encode(utf8.encode('$consumerKey:$consumerSecret')),
  //     // },
  //     body: jsonEncode({
  //       'email': 'test123@example.com',
  //       'first_name': 'test123',
  //       'last_name': 'World',
  //       'password': '123456',
  //     }),
  //   );

  //   if (response.statusCode == 201) {
  //     print('Customer created successfully');
  //     print('Response body: ${response.body}');
  //   } else {
  //     print('Failed to create customer. Response code: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //   }
  // }

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
  final dio = Dio();
  Future<void> createCustomer(CustomerModel customer) async {
    try {
      var response = await dio.post(
        "${Config.url}${Config.customerURL}?consumer_key=${Config.key}&consumer_secret=${Config.secret}",
        data: customer.toJson(),
      );

      log(response.toString());
    } catch (e) {
      log("Error: ${e.toString()}");
    }
  }
}
*/
/*
class APIService {
  Future<bool> createCustomer(CustomerModel customer) async {
    var authToken = base64.encode(
      utf8.encode("${Config.key}:${Config.secret}"),
    );

    bool ret = false;

    try {
      var response = await Dio().post(
        "https://grocerystore.skygoaltech.com//wp-json/wc/v3/customers?consumer_key=ck_c6104bbac4a739e08e6e56ecd72c60218ad8012c&consumer_secret=cs_7662eca8cf33f288a8e94f0c12ac9004c9d7f507&email=john.doe@example.com",
        data: customer.toJson(),
        // options: Options(
        //   headers: {
        //     HttpHeaders.authorizationHeader: 'Basic $authToken',
        //     HttpHeaders.contentTypeHeader: 'application/json'
        //   },
        // ),
      );
      log(response.toString());
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
