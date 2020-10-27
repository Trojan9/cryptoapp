import 'dart:convert';

import 'package:cryptoapp/homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() async {
  List currency = await _getcurrencies();
  runApp(MyApps(currency));
}

class MyApps extends StatefulWidget {
  // This widget is the root of your application.
  final List currency;
  MyApps(this.currency);
  @override
  _MyAppsState createState() => _MyAppsState();
}

class _MyAppsState extends State<MyApps> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(widget.currency),
    );
  }
}

Future<List> _getcurrencies() async {
  Map parameters = {'start': '1', 'limit': '5000', 'convert': 'USD'};
  Map<String, String> headers = {
    'Accepts': 'application/json',
    'X-CMC_PRO_API_KEY': 'b54bcf4d-1bca-4e8e-9a24-22ff2c3d462c',
  };
  var limit = json.encode(parameters);
  String linkurl = "https://undefined/v1/cryptocurrency/listings/latest";
  Response response = await get(
    linkurl,
    headers: headers,
  );
  var responseBody = jsonDecode(response.body);
  return responseBody.toList();
}
