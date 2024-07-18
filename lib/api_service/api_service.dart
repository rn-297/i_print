import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as Http;

import '../helper/print_constants.dart';

abstract class ApiClient extends GetxService {
  static const int timeoutInSeconds = 30;
  static var client = Http.Client();
  static String replicateApiToken = "r8_6ZfaTTILN2r9NgdXIbixX82BL3yK6qi0Oo1Wx";

  static Future<Response> getData(String uri) async {
    try {
      Http.Response response0 = await client
          .get(Uri.parse(uri))
          .timeout(const Duration(seconds: timeoutInSeconds));
      Response response = Response(
        body: response0.body,
        statusCode: response0.statusCode,
      );
      print(response.body);
      return response;
    } catch (ex) {
      return const Response(
          statusCode: 1, statusText: AppConstants.noInternetConnection);
    }
  }

  static Future<String> getHeaderData(String uri) async {
    try {
      Map<String, String> headers = {
        "Authorization": "Bearer $replicateApiToken",
        "Content-Type": "application/json",
      };

      Http.Response response0 = await client
          .get(Uri.parse(uri),
          headers: headers)
          .timeout(const Duration(seconds: timeoutInSeconds));
      Response response = Response(
        body: response0.body,
        statusCode: response0.statusCode
      );
      print(response0.statusCode);
      print(json.decode(response0.body)["status"]);
      if (response0.statusCode == 200) {
        // Parse the response JSON
        Map<String, dynamic> responseData = json.decode(response0.body);

        // Extract status
        String status = responseData['status'];

        // Check if status is "succeeded"
        if (status == "succeeded") {
          // If status is "succeeded", print the output and return
          print(responseData['output']);
          String output = responseData['output'][0];
          print("Output: $output");
          return output;
        } if(status == "failed"){return "";}else {
          // If status is not "succeeded", wait for 2 seconds and call the function recursively
          await Future.delayed(const Duration(seconds: 2));
          String output=await getHeaderData(uri);
          return output;

        }

    }
    return"";
    }catch (ex) {
      return "";
    }
  }

  static Future<dynamic> postData(String uri, dynamic body) async {
    try {
      // print(AppConstants.BASE_URL + uri);
      // print(body);

      var response = await client
          .post(
            Uri.parse(uri),
            body: body,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      // print(_response.);

      return response;
    } catch (ex) {
      // print(ex);
      return const Response(
          statusCode: 1, statusText: AppConstants.noInternetConnection);
    }
  }

  static Future<dynamic> postHeaderData(String uri, dynamic body,String apiKey) async {
    try {
      // print(AppConstants.BASE_URL + uri);
      // print(body);
      Map<String, String> headers = {
        "Authorization": "Bearer $apiKey",
        'Accept': 'application/json',
        "Content-Type": "application/json",
      };

      var response = await client
          .post(Uri.parse(uri), body: json.encode(body), headers: headers)
          .timeout(const Duration(seconds: timeoutInSeconds));
      print(response.body);


      return response;
    } catch (ex) {
      print(ex);
      return const Response(
          statusCode: 1, statusText: AppConstants.noInternetConnection);
    }
  }

  static Future<dynamic> postHeaderMultipartData(Http.MultipartRequest request, String apiKey) async {
    try {
      // print(AppConstants.BASE_URL + uri);
      // print(body);
      request=request..headers['Authorization'] = 'Bearer $apiKey'
        ..headers['Accept'] = 'application/json'
        ..headers['Content-type'] = 'multipart/form-data'
      ;
      print(request.fields);
      final Http.StreamedResponse streamedResponse = await request.send();
      print(streamedResponse.statusCode);

      return streamedResponse;
    } catch (ex) {
      print(ex);
      return const Response(
          statusCode: 1, statusText: AppConstants.noInternetConnection);
    }
  }
  static Future<dynamic> postHeaderMultipartData1(Http.MultipartRequest request, String apiKey) async {
    try {
      // print(AppConstants.BASE_URL + uri);
      // print(body);
      request=request..headers['Authorization'] = 'Bearer $apiKey'
        ..headers['Accept'] = 'application/json'
        ..headers['Content-type'] = 'application/json'
      ;
      print(request.fields);
      final Http.StreamedResponse streamedResponse = await request.send();
      print(streamedResponse.statusCode);

      return streamedResponse;
    } catch (ex) {
      print(ex);
      return const Response(
          statusCode: 1, statusText: AppConstants.noInternetConnection);
    }
  }

  static Future<dynamic> postListData(String uri, dynamic body) async {
    try {
      // print(AppConstants.BASE_URL + uri);
      // print(body);

      var response = await client.post(Uri.parse(uri), body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).timeout(const Duration(seconds: timeoutInSeconds));

      return response;
    } catch (ex) {
      // print(ex);
      return const Response(
          statusCode: 1, statusText: AppConstants.noInternetConnection);
    }
  }
}
