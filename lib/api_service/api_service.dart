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
      Http.Response _response = await client
          .get(Uri.parse(uri))
          .timeout(Duration(seconds: timeoutInSeconds));
      Response response = Response(
        body: _response.body,
        statusCode: _response.statusCode,
      );
      print(response.body);
      return response;
    } catch (ex) {
      return Response(
          statusCode: 1, statusText: AppConstants.noInternetConnection);
    }
  }

  static Future<String> getHeaderData(String uri) async {
    try {
      Map<String, String> headers = {
        "Authorization": "Bearer $replicateApiToken",
        "Content-Type": "application/json",
      };

      Http.Response _response = await client
          .get(Uri.parse(uri),
          headers: headers)
          .timeout(Duration(seconds: timeoutInSeconds));
      Response response = Response(
        body: _response.body,
        statusCode: _response.statusCode
      );
      print(_response.statusCode);
      print(json.decode(_response.body)["status"]);
      if (_response.statusCode == 200) {
        // Parse the response JSON
        Map<String, dynamic> responseData = json.decode(_response.body);

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
          await Future.delayed(Duration(seconds: 2));
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

      var _response = await client
          .post(
            Uri.parse(uri),
            body: body,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      // print(_response.);

      return _response;
    } catch (ex) {
      // print(ex);
      return Response(
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

      var _response = await client
          .post(Uri.parse(uri), body: json.encode(body), headers: headers)
          .timeout(Duration(seconds: timeoutInSeconds));
      print(_response.body);


      return _response;
    } catch (ex) {
      print(ex);
      return Response(
          statusCode: 1, statusText: AppConstants.noInternetConnection);
    }
  }

  static Future<dynamic> postHeaderMultipartData(Http.MultipartRequest request, String apiKey) async {
    try {
      // print(AppConstants.BASE_URL + uri);
      // print(body);
      request=request..headers['Authorization'] = 'Bearer $apiKey'
        ..headers['Accept'] = 'application/json';
      print(request.fields);
      final Http.StreamedResponse streamedResponse = await request.send();
      print(streamedResponse.statusCode);

      return streamedResponse;
    } catch (ex) {
      print(ex);
      return Response(
          statusCode: 1, statusText: AppConstants.noInternetConnection);
    }
  }

  static Future<dynamic> postListData(String uri, dynamic body) async {
    try {
      // print(AppConstants.BASE_URL + uri);
      // print(body);

      var _response = await client.post(Uri.parse(uri), body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).timeout(Duration(seconds: timeoutInSeconds));

      return _response;
    } catch (ex) {
      // print(ex);
      return Response(
          statusCode: 1, statusText: AppConstants.noInternetConnection);
    }
  }
}
