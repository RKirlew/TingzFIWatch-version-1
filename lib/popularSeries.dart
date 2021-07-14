import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class popularSeries extends StatefulWidget {
  const popularSeries({Key? key}) : super(key: key);

  @override
  _popularSeriesState createState() => _popularSeriesState();
}

class _popularSeriesState extends State<popularSeries> {
  var page=1;

  fetchSeries() async {


    var url;
    url = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/tv/popular?api_key={api_key}&language=en-US&page="+page.toString()));
    return json.decode(url.body)['results'];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,
      appBar: AppBar(

        centerTitle: true,
        title:Column(
          children:<Widget> [
            SizedBox(height:20),




            Text("Popular Series", style: TextStyle(color: Colors.red, fontSize: 20,),),
           TextField(onSubmitted: (value) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => seriesSearch(),
                      // Pass the arguments as part of the RouteSettings. The
                      // DetailScreen reads the arguments from these settings.
                      settings: RouteSettings(
                        arguments: value,
                      )));

            },

              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: InputBorder.none,

                  hintText: "Search Series Here",

                  hintStyle: TextStyle(color: Colors.white, )),
            ),

          ],
        ),

        elevation: 0.0,
        backgroundColor: Colors.black,
      ),

      body: FutureBuilder(
          future: fetchSeries(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.hasData) {

              return ListView.builder(

                shrinkWrap: true,
                itemCount: snapshot.data.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (BuildContext context, int index) {
                  if(snapshot.data[index]['poster_path']!=null) {
                    return Row(

                      children: [
                        SizedBox(height: 30),

                        Container(
                          height: 250,
                          alignment: Alignment.centerLeft,
                          child: Card(
                            child: Image.network(
                                "https://image.tmdb.org/t/p/w500" +
                                    snapshot.data[index]['poster_path']),
                          ),
                        ),

                        SizedBox(width: 20,),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20.0,
                                ),

                                Text(
                                  snapshot.data[index]["original_name"],
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data[index]["first_air_date"],
                                  style: TextStyle(color: Color(0xff868597)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data[index]["vote_average"]
                                      .toString() + "/10 ⭐",
                                  style: TextStyle(color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),

                                ),
                                Container(
                                  height: 100,
                                  child: Text(
                                    snapshot.data[index]["overview"],
                                    style: TextStyle(color: Color(0xff868597)),
                                  ),

                                ),

                              ],

                            ),

                          ),

                        ),

                      ],
                    );
                  }else{
                    return Text("No image");
                  }
                },

              );

            }

            return Center(
              child: CircularProgressIndicator(),
            );

          }),
      floatingActionButton: FloatingActionButton.extended(backgroundColor:Colors.red,label:
      Text("Next Page",style: TextStyle(color:Colors.white),),
        onPressed: (){

          setState(() {
            page+=1;
          });
        },
      ),

    );
  }


}
class seriesSearch extends StatefulWidget {
  const seriesSearch({Key? key}) : super(key: key);

  @override
  _seriesSearchState createState() => _seriesSearchState();
}

class _seriesSearchState extends State<seriesSearch> {
  var page=1;
  seriesFetch (String value) async {
    var url;
    url = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/search/tv?api_key={api_key}&language=en-US&page="+page.toString()+"&query="+value));
    return json.decode(url.body)['results'];
  }
  @override
  Widget build(BuildContext context) {
    var seriesName = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(

      backgroundColor: Colors.black,
      appBar: AppBar(

        centerTitle: true,
        title:Column(
          children:<Widget> [

            SizedBox(height:20),

            Text("Search Results", style: TextStyle(color: Colors.red, fontSize: 20,),),
            TextField(onSubmitted: (value) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => seriesSearch(),
                      // Pass the arguments as part of the RouteSettings. The
                      // DetailScreen reads the arguments from these settings.
                      settings: RouteSettings(
                        arguments: value,
                      )));

            },

              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: InputBorder.none,

                  hintText: "Search Series Here",
                  hintStyle: TextStyle(color: Colors.white, )),
            ),

          ],
        ),

        elevation: 0.0,
        backgroundColor: Colors.black,
      ),

      body: FutureBuilder(
          future:    seriesFetch(seriesName),

          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.hasData) {

              return ListView.builder(

                shrinkWrap: true,
                itemCount: snapshot.data.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (BuildContext context, int index) {
                  if(snapshot.data[index]['poster_path']!=null) {
                    return Row(

                      children: [
                        SizedBox(height: 30),

                        Container(
                          height: 250,
                          alignment: Alignment.centerLeft,
                          child: Card(
                            child: Image.network(
                                "https://image.tmdb.org/t/p/w500" +
                                    snapshot.data[index]['poster_path']),
                          ),
                        ),

                        SizedBox(width: 20,),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20.0,
                                ),

                                Text(
                                  snapshot.data[index]["original_name"],
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data[index]["first_air_date"],
                                  style: TextStyle(color: Color(0xff868597)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data[index]["vote_average"]
                                      .toString() + "/10 ⭐",
                                  style: TextStyle(color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),

                                ),
                                Container(
                                  height: 100,
                                  child: Text(
                                    snapshot.data[index]["overview"],
                                    style: TextStyle(color: Color(0xff868597)),
                                  ),

                                ),

                              ],

                            ),

                          ),

                        ),

                      ],
                    );
                  }else{
                    return Text("No image");
                  }
                },

              );

            }

            return Center(
              child: CircularProgressIndicator(),
            );

          }),
      floatingActionButton: FloatingActionButton.extended(backgroundColor:Colors.red,label:
      Text("Next Page",style: TextStyle(color:Colors.white),),
        onPressed: (){

          setState(() {
            page+=1;
          });
        },
      ),

    );
  }
}
