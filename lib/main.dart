import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paytm/paytm.dart';
import 'dart:io';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String payment_response = null;

  String mid = "GOTOMO73900295040858";
  String PAYTM_MERCHANT_KEY = "N@wjo8rCE#QuPnU%";
  String website = "DEFAULT";
  double amount = 1.0;
  bool loading = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Paytm example app'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Use Production Details Only'),

                SizedBox(
                  height: 10,
                ),

//                TextField(
//                  onChanged: (value) {
//                    mid = value;
//                  },
//                  decoration: InputDecoration(hintText: "Enter MID here"),
//                  keyboardType: TextInputType.text,
//                ),
//                TextField(
//                  onChanged: (value) {
//                    PAYTM_MERCHANT_KEY = value;
//                  },
//                  decoration:
//                  InputDecoration(hintText: "Enter Merchant Key here"),
//                  keyboardType: TextInputType.text,
//                ),
//                TextField(
//                  onChanged: (value) {
//                    website = value;
//                  },
//                  decoration: InputDecoration(
//                      hintText: "Enter Website here (Probably DEFAULT)"),
//                  keyboardType: TextInputType.text,
//                ),
//                TextField(
//                  onChanged: (value) {
//                    try {
//                      amount = double.tryParse(value);
//                    } catch (e) {
//                      print(e);
//                    }
//                  },
//                  decoration: InputDecoration(hintText: "Enter Amount here"),
//                  keyboardType: TextInputType.number,
//                ),
                SizedBox(
                  height: 10,
                ),
                payment_response != null
                    ? Text('Response: $payment_response\n')
                    : Container(),
                RaisedButton(
                  onPressed: () {
                    //Firstly Generate CheckSum bcoz Paytm Require this
                    generateTxnToken(0);
                  },
                  color: Colors.blue,
                  child: Text(
                    "Pay using Wallet",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    //Firstly Generate CheckSum bcoz Paytm Require this
                    generateTxnToken(1);
                  },
                  color: Colors.blue,
                  child: Text(
                    "Pay using Net Banking",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    //Firstly Generate CheckSum bcoz Paytm Require this
                    generateTxnToken(2);
                  },
                  color: Colors.blue,
                  child: Text(
                    "Pay using UPI",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    //Firstly Generate CheckSum bcoz Paytm Require this
                    generateTxnToken(3);
                  },
                  color: Colors.blue,
                  child: Text(
                    "Pay using Credit Card",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void generateTxnToken(int mode) async {
    setState(() {
      loading = true;
    });
    String address;
    if(Platform.isIOS){
      address="localhost";
    }
    else if(Platform.isAndroid)
      {
      address="10.0.2.2";
    }
    

    PAYTM_MERCHANT_KEY=PAYTM_MERCHANT_KEY.replaceAll("#", "%23");
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    String callBackUrl =
        'https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=' + orderId;
    print("$callBackUrl");
    print(mode);

    var url =
        'http://$address:3000/generateTxnToken' +
            "?mid=" +
            mid +
            "&key_secret=" +
            PAYTM_MERCHANT_KEY +
            "&website=" +
            website +
            "&orderId=" +
            orderId +
            "&amount=" +
            amount.toString() +
            "&callbackUrl=" +
            callBackUrl +
            "&custId=" +
            "122" +
            "&mode=" +
            mode.toString();

    //String urlMy="http://127.0.0.1:3000/generateTxnToken?mid=GOTOMO73900295040858&key_secret=N@wjo8rCE%23QuPnU%&website=DEFAULT&orderId=hjkdfjsdhfsdfjfdgkdgfgdkjf&amount=1&callbackUrl=https://www.google.co.in&custId=122&mode=0";

    final response = await http.get(url);

    print("Response is");
    print(response.body);
    String txnToken = response.body;
    setState(() {
      payment_response = txnToken;
    });

    var paytmResponse = Paytm.payWithPaytm(
      mid,
      orderId,
      txnToken,
      amount.toString(),
      callBackUrl,
    );

    paytmResponse.then((value) {
      print(value);
      setState(() {
        loading = false;
        payment_response = value.toString();
      });
    });
  }
}