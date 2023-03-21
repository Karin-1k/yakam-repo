import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin data.dart';
import 'dart:io' show Platform;
import 'coin data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  DropdownButton getDropDownButton_for_android() {
    List<DropdownMenuItem<String>> currentText = [];
    for (int i = 0; i < currenciesList.length; i++) {
      var x = DropdownMenuItem(
        child: Text(currenciesList[i]),
        value: currenciesList[i],
      );
      currentText.add(x);
    }

    return DropdownButton<String>(
      value: slectedCurrency,
      items: currentText,
      onChanged: (value) {
        setState(() {
          slectedCurrency = value!;
          getPrice();
        });
      },
    );
  }

  CupertinoPicker getCupertinoPecker_for_IOS() {
    List<Widget> picker_list = [];

    for (int i = 0; i < currenciesList.length; i++) {
      picker_list.add(
        Text(
          currenciesList[i],
        ),
      );
    }

    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: ((SlectedIndex) {
        setState(() {
          slectedCurrency = currenciesList[SlectedIndex];
          getPrice();
        });
      }),
      children: picker_list,
    );
  }

  String slectedCurrency = 'USD';
  int? currency = 0;
  String? left_Currency = 'null';
  String? right_currency = 'null';

//get the current currency

  Future getPrice() async {
    CoinData coinData = CoinData(slectedCurrency);
    try {
      var price = await coinData.getCurrentPrice();

      setState(() {
        double c = price['rate'];
        currency = c.toInt();
        left_Currency = price['asset_id_base'];
        right_currency = price['asset_id_quote'];
      });
    } catch (e) {
      print('the error is $e');
    }
  }

  Widget disign(String l_c, String r_c, int c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding:const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $l_c = $c $r_c',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();

    getPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          disign(cryptoList[0], right_currency!, currency!),
          disign(cryptoList[1], right_currency!, currency!),
          disign(cryptoList[2], right_currency!, currency!),
          Expanded(child: Container()),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS
                ?getDropDownButton_for_android()
                : getCupertinoPecker_for_IOS(),
          ),
        ],
      ),
    );
  }
}
 