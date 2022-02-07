class Crypto{

String name;
String symbol;
Quote quote;

Crypto( this.name, this.symbol, this.quote);

  factory Crypto.fromJson(Map<String,dynamic> json){


return Crypto(
    json['name'] as String,
    json['symbol'] as String,
    Quote.fromJson(json["quote"])

);

}


}

class Quote{

USD usd;


Quote(this.usd);

factory Quote.fromJson(Map<String, dynamic> json){

  return Quote(USD.fromJson(json["USD"]));

}


}


class USD{

double price;
double percent_change_1h;

USD(this.price, this.percent_change_1h);

factory USD.fromJson(Map<String,dynamic> json){

  return USD(json['price'] as double, json['percent_change_1h']);

}

}




