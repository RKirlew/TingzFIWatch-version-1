
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home_page.dart';


class categoryPage extends StatefulWidget {


  @override
  _categoryPageState createState() => _categoryPageState();
}
fetchGenres() async {


  var url;
  url = await http.get(Uri.parse(
      "https://api.themoviedb.org/3/genre/movie/list?api_key={api_key}&language=en-US"));
  return json.decode(url.body)['genres'];
}


class _categoryPageState extends State<categoryPage> {
  String genreName='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
     appBar: AppBar(
       title: Text("Category Page"),
       backgroundColor: Colors.red,
     ),
      body: FutureBuilder(
          future: fetchGenres(),
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

                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => theSelectedCategory(),
                                      // Pass the arguments as part of the RouteSettings. The
                                      // DetailScreen reads the arguments from these settings.
                                      settings: RouteSettings(
                                        arguments: snapshot.data[index]['id'].toString()
                                      )));
                            },
                            onLongPress: () {
                              // open dialog OR navigate OR do what you want
                            },
                            child:


                         Container(

                            height: 50,
                            width:MediaQuery.of(context).size.width-16,
                            color: Colors.white,
                            alignment: Alignment.centerLeft,
                            child: Card(

                              child:Text(snapshot.data[index]['name']),
                            ),
                          ),

                        )
                ]
                    ),
                  );


                },

              );

            }

            return Center(
              child: CircularProgressIndicator(),
            );

          }) ,
    );
  }
}
class theSelectedCategory extends StatefulWidget {

  @override
  _theSelectedCategoryState createState() => _theSelectedCategoryState();
}

class _theSelectedCategoryState extends State<theSelectedCategory> {
  var page=1;

  fetchMovieByGenre(String genreID) async {


    var url;
    url = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/discover/movie?api_key={api_key}&with_genres="+genreID));
    return json.decode(url.body)['results'];
  }
  @override
  Widget build(BuildContext context) {
    var genreID = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(

      backgroundColor: Colors.black,
      appBar: AppBar(

        centerTitle: true,
        title:Column(
          children:<Widget> [


            Text("Search Results", style: TextStyle(color: Colors.red, fontSize: 20,),),

          ],
        ),

        elevation: 0.0,
        backgroundColor: Colors.black,
      ),

      body: FutureBuilder(
          future: fetchMovieByGenre(genreID.toString()),
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

                  return Row(

                    children: [
                      SizedBox(height:30),

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
                                snapshot.data[index]["original_title"],
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                snapshot.data[index]["release_date"],
                                style: TextStyle(color: Color(0xff868597)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                snapshot.data[index]["vote_average"].toString()+"/10 ⭐",
                                style: TextStyle(color:Colors.white,fontSize: 18,fontWeight: FontWeight.bold),

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
