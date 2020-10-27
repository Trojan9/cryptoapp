import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  final List currencies;
  MyHomePage(this.currencies);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List currencies;
  final List<MaterialColor> _colors = [Colors.blue, Colors.indigo, Colors.red];
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    currencies = await _getcurrencies();
  }

  Future<List> _getcurrencies() async {
    Map parameters = {'start': '1', 'limit': '5000', 'convert': 'USD'};
    Map<String, String> headers = {
      'Accepts': 'application/json',
      'X-CMC_PRO_API_KEY': 'b54bcf4d-1bca-4e8e-9a24-22ff2c3d462c',
    };
    var limit = json.encode(parameters);
    String linkurl =
        "https://undefined/v1/cryptocurrency/listings/latest?limit=50&start=1&convert=USD";
    Response response = await get(
      linkurl,
      headers: headers,
    );
    var responseBody = jsonDecode(response.body);
    return responseBody.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crypto App"),
      ),
      body: _crptoappbody(context),
    );
  }

  Widget _crptoappbody(BuildContext context) {
    return Container(
      child: Flexible(
          child: ListView.builder(
              itemCount: widget.currencies.length,
              itemBuilder: (BuildContext context, int index) {
                final Map currency = widget.currencies[index];
                final MaterialColor _color = _colors[index % _colors.length];
                return _getlistitemmenuUI(currency, _color);
              })),
    );
  }

  ListTile _getlistitemmenuUI(Map currency, MaterialColor color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: new Text(currency['name']
            [0]), //another way of using the first letter in a name
      ),
      title: new Text(
        currency['name'],
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: _getsubtitletext(
          currency['price_usd'], currency['percent_change_1h']),
    );
  }

  Widget _getsubtitletext(String priceUsd, String percentageChange) {
    TextSpan priceTextWidget = new TextSpan(
        text: "\$$priceUsd", style: TextStyle(color: Colors.black));
    String percentageChangeText = "1 hour:$percentageChange%";
    TextSpan percentageChangeTextWidget;
    if (double.parse(percentageChange) > 0) {
      percentageChangeTextWidget = new TextSpan(
          text: percentageChangeText, style: TextStyle(color: Colors.green));
    } else {
      percentageChangeTextWidget = new TextSpan(
          text: percentageChangeText, style: TextStyle(color: Colors.red));
    }
    return new RichText(
        text: new TextSpan(
            children: [priceTextWidget, percentageChangeTextWidget]));
  }
}
