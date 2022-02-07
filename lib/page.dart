import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

import 'crypto.dart';

class CryptoPage extends StatefulWidget {


  String name;
  String img;
  int index;
  List<double> currencyData;
  List<String> timeStamp;
  List<String> dataString = [];



  CryptoPage(this.name, this.img,this.currencyData, this.timeStamp, this.index);

  @override
  _CryptoPageState createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  Future<List<Crypto>> getCurrencies() async {

    var url = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?CMC_PRO_API_KEY=925e97df-9002-4cb5-be32-04b12fa52240&limit=10";
    var respond = await http.get(url);
    var jsonData = json.decode(respond.body);
    var jsonArray = jsonData["data"] as List;
    cryptoList = jsonArray.map((obj) => Crypto.fromJson(obj)).toList();

    return cryptoList;

  }

  Color chooseColor(){
    var color;
    if(widget.currencyData.length <= 1){
      return Colors.black;
    }
    if(widget.currencyData[widget.currencyData.length-1] < widget.currencyData[widget.currencyData.length-2]){
      color = Colors.red;
    }else if(widget.currencyData[widget.currencyData.length-1] > widget.currencyData[widget.currencyData.length-2]){
      color = Colors.green;
    }else{
      color = Colors.black;
    }

    return color;
  }

  Future<void> showCurrency() async {

    cryptoList = await getCurrencies();
    widget.currencyData.add(cryptoList[widget.index].quote.usd.price);

    DateTime now = DateTime.now();
    widget.timeStamp.add(now.hour.toString() + ":" + now.minute.toString() + ":" + now.second.toString());

    chartData.add(CryptoData(cryptoList[widget.index].quote.usd.price, widget.timeStamp.last));

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => super.widget));

  }

  List<Crypto> cryptoList = [];



  List<Feature> features = [];

  void initState(){
    super.initState();
    chartData = getChartData();


  }

  List<CryptoData> chartData = [];

  List<CryptoData> getChartData(){
     List<CryptoData> cryptoData = [];

     for(int i = 0; i < widget.currencyData.length; i++){

         cryptoData.add(CryptoData(widget.currencyData[i], widget.timeStamp[i]));


     }

        return cryptoData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text("CryptoCatch",style: TextStyle(color: Colors.white),),
         actions: [
           MaterialButton(onPressed: (){

             setState(() {
                showCurrency();


             });

           }, child: Icon(Icons.refresh,color: Colors.white,),),
         ],
       ),
       body: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           SizedBox(height: 30,),

           Row(

           children: [
              SizedBox(width: 125,),
             SizedBox(
                 height: 50,
                 width: 50,
                 child: Image.asset("./img/${widget.img}")),
             SizedBox(width: 10,),
             Text("${widget.name} Chart",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),

           ],


         ),
           SizedBox(height: 20,),

          SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries> [LineSeries<CryptoData, String>(dataSource: chartData,
                yValueMapper: (CryptoData price, _) => price.price,
                color: chooseColor(),
                dataLabelSettings: DataLabelSettings(isVisible: true,showZeroValue: false,) ,
            xValueMapper: (CryptoData time, _) => time.time,)



            ],


          )

        ],
       ),


    );
  }



}


class CryptoData{
  CryptoData(this.price, this.time);
  final double? price;
  final String time;
}
