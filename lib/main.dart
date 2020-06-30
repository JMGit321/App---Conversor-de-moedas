import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';//request sem travar os programas
import 'dart:convert';
const request = "https://api.hgbrasil.com/finance?format=json-cors&key=12345678";//12345678 é o codigo da chave, obs:codigo inventado
/*Caso queria obter um codigo para uso proprio entre em https://hgbrasil.com/status/finance*/



void main() async{
  //http.Response response = await http.get(request);
  //print(response.body);//corpo da requisição http
  //print(json.decode(response.body)["results"]["currencies"]["USD"]["buy"]);//decodificando o json
  //print(await getData());//pega os dados a qualquer momento mesmo no futuro
  runApp(MaterialApp(
    title: "Conversor de moedas",
    home: Home(),
    theme: ThemeData(

        hintColor: Colors.amberAccent,
        primaryColor: Colors.amberAccent,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
          hoverColor: Colors.amberAccent,
        )),


  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final euroController = TextEditingController();
  final dolarController = TextEditingController();

  double dolar;
  double euro;
  double real;
  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }
  void _realChange(String text){
    if(text.isEmpty){
      _clearAll();
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dolarChange(String text){
    if(text.isEmpty){
      _clearAll();
    }
    double dolar = double.parse(text);
    realController.text = (dolar*this.dolar).toStringAsFixed(2);
    euroController.text = (dolar*this.dolar/euro).toStringAsFixed(2);
  }
  void _euroChange(String text){
    if(text.isEmpty){
      _clearAll();
    }
    double euro = double.parse(text);
    dolarController.text = (euro*this.euro/dolar).toStringAsFixed(2);
    realController.text = (euro*this.euro).toStringAsFixed(2);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            "\$ Conversor de Moedas \$",
        ),
        backgroundColor: Colors.amberAccent,
      ),
      body: FutureBuilder(
        future: getData(),//pega o futuro
        builder: (context,snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando dados",
                  style: TextStyle(color: Colors.amberAccent,fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text("Erro ao carregar dados",
                    style: TextStyle(color: Colors.amberAccent,fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              }else{

                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,//cobre tudo e joga no centro,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 150,
                          color: Colors.amberAccent,
                        ),
                        buildTextField("Reais", "R\$",realController,_realChange),

                        Divider(),
                        buildTextField("Doláres", "US\$",dolarController,_dolarChange),

                        Divider(),
                        buildTextField("Euros", "€",euroController,_euroChange),
                      ],
                    ),
                );
              }


          }
        },
      ),
    ) ;
  }
}

Future<Map> getData() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

Widget buildTextField(String label,String prefix,TextEditingController c,Function f){
  return  TextField(
    //cursorColor: Colors.amberAccent, cor da barrinha
    controller: c,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      prefixText: prefix,
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.amber,
        fontSize: 25,
      ),
      border: OutlineInputBorder(

      ),
    ),
    style: TextStyle(color: Colors.amberAccent,fontSize: 25),
    onChanged: f,
  );
}