import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class randomSeries extends StatefulWidget {

  @override
  _randomSeriesState createState() => _randomSeriesState();
}

class _randomSeriesState extends State<randomSeries> {
  var page=1;
  @override
  Widget build(BuildContext context) {
   return Scaffold(

      backgroundColor: Colors.black,
      appBar: AppBar(

        centerTitle: true,
        title:Column(
          children:<Widget> [


            Text("Random Series", style: TextStyle(color: Colors.red, fontSize: 20,),),


          ],
        ),

        elevation: 0.0,
        backgroundColor: Colors.black,
      ),

      body: FutureBuilder(
          future: fetchRandomSeries(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.hasData) {

              var i=snapshot.data.length;
              print(i);
              Random rnd;

              rnd = new Random();
              int randomNumber = rnd.nextInt(i);
              var index=randomNumber;

              return Row(

                children: [


                  Center(
                    child: Container(
                      height: 350,
                      alignment: Alignment.centerLeft,
                      child: Card(
                        child: Image.network(
                            "https://image.tmdb.org/t/p/w500" +
                                snapshot.data[index]['poster_path']),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(

                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [



                            Text(
                              snapshot.data[index]["original_name"],
                              style: TextStyle(color: Colors.white,fontSize: 30),
                              overflow: TextOverflow.fade,
                            ),

                            Text(
                              snapshot.data[index]["first_air_date"],
                              style: TextStyle(color: Color(0xff868597)),
                            ),

                            Text(
                              snapshot.data[index]["vote_average"].toString()+"/10 ⭐",
                              style: TextStyle(color:Colors.white,fontSize: 18,fontWeight: FontWeight.bold),

                            ),
                            Container(
                              height: 400,
                              child: Text(
                                snapshot.data[index]["overview"],
                                style: TextStyle(color: Color(0xff868597),fontSize: 20),
                                overflow: TextOverflow.fade,
                              ),

                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  page=index;
                                });
                              },
                              child:
                              Icon(Icons.refresh,color: Colors.white,size: 40,),
                            ),
                          ]
                      ),

                    ),

                  ),

                ],
              );





            }

            return Center(
              child: CircularProgressIndicator(),
            );

          }),

    );
  }
  fetchRandomSeries() async {
    var url;
    url = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/tv/popular?api_key={api_key}&language=en-US&page="+page.toString()));
    return json.decode(url.body)['results'];
  }
}
