import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycurrencyapp/crypto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mycurrencyapp/page.dart';

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Crypto> cryptoList = [];
  List<String> cryptoImg = ["btc.png","eth.png","tet.png","bnb.png","card.png","xrp.png","usdc.png","doge.png","polka.png","uni.png"];
  List<double> bit_value = [];
  List<double> eth_value = [];
  List<double> tet_value = [];
  List<double> bnb_value = [];
  List<double> card_value = [];
  List<double> xrp_value = [];
  List<double> usdc_value = [];
  List<double> doge_value = [];
  List<double> polka_value = [];
  List<double> uni_value = [];
  List<List<double>> valueList = [];
  List<String> timeStamp = [];





  Widget findColor(String str){

    TextSpan txt;
    String lastText = "%$str";
    if(double.parse(str) < 0){

      txt = TextSpan(text: lastText,style: TextStyle(color: Colors.red));

    }else if(double.parse(str) > 0){
      txt = TextSpan(text: lastText,style: TextStyle(color: Colors.green));

    }else{
      txt = TextSpan(text: lastText,style: TextStyle(color: Colors.black));
    }

    return RichText(text: TextSpan(children: [txt]));

  }

  Future<List<Crypto>> getCurrencies() async {

    var url = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?CMC_PRO_API_KEY=925e97df-9002-4cb5-be32-04b12fa52240&limit=10";
    var respond = await http.get(url);
    var jsonData = json.decode(respond.body);
    var jsonArray = jsonData["data"] as List;
    cryptoList = jsonArray.map((obj) => Crypto.fromJson(obj)).toList();

    return cryptoList;

  }

  Future<void> showCurrency() async {

    cryptoList = await getCurrencies();
    DateTime now = DateTime.now();
    timeStamp.add(now.hour.toString() + ":" + now.minute.toString() + ":" + now.second.toString());


    bit_value.add(cryptoList[0].quote.usd.price);
    eth_value.add(cryptoList[1].quote.usd.price);
    tet_value.add(cryptoList[2].quote.usd.price);
    bnb_value.add(cryptoList[3].quote.usd.price);
    card_value.add(cryptoList[4].quote.usd.price);
    xrp_value.add(cryptoList[5].quote.usd.price);
    usdc_value.add(cryptoList[6].quote.usd.price);
    doge_value.add(cryptoList[7].quote.usd.price);
    polka_value.add(cryptoList[8].quote.usd.price);
    uni_value.add(cryptoList[9].quote.usd.price);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    valueList.add(bit_value);
    valueList.add(eth_value);
    valueList.add(tet_value);
    valueList.add(bnb_value);
    valueList.add(card_value);
    valueList.add(xrp_value);
    valueList.add(usdc_value);
    valueList.add(doge_value);
    valueList.add(polka_value);
    valueList.add(uni_value);
    showCurrency();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CatchCoin",style: TextStyle(color: Colors.white),),

        actions: [
          Row(
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: MaterialButton(onPressed: () async {

                  await FirebaseAuth.instance.signOut();

                },child: Icon(Icons.logout, color: Colors.white,),),
              ),

              SizedBox(
                width: 60,
                height: 50,
                child: MaterialButton(onPressed: (){

                  setState(() {
                    showCurrency();
                  });

                },child: Icon(Icons.refresh,color: Colors.white,),),
              )
            ],
          )
        ],
      ),

      body: FutureBuilder(

        future: getCurrencies(),
        builder: (context,snapshot) {
          if(snapshot.hasData) {
            return ListView.builder(
              itemExtent: 70,
              itemCount: cryptoList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){

                    Navigator.push(context, MaterialPageRoute(builder: (context) => CryptoPage(cryptoList[index].name, cryptoImg[index],valueList[index],timeStamp, index)));

                  },
                  child: ListTile(

                    leading: CircleAvatar(
                      child: Image.asset("./img/${cryptoImg[index]}"),

                    ),

                    title: Row(children: [


                      Text(cryptoList[index].name),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text("\$${cryptoList[index].quote.usd.price
                              .toStringAsFixed(3)}"),
                          SizedBox(height: 5,),
                          findColor("${cryptoList[index].quote.usd.percent_change_1h
                              .toStringAsFixed(3)}"),

                        ],

                      ),


                    ],),


                  ),
                );
              },
            );
          }else{
            return Center();
          }
        },
      ),
    );
  }


}