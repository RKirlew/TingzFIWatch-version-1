import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:learn_flutter/popularSeries.dart';
import 'package:learn_flutter/random_page.dart';
import 'package:learn_flutter/random_series.dart';
import 'package:flutter/services.dart';
import 'category_page.dart';


class test extends StatefulWidget {

  const test({Key? key}) : super(key: key);

  @override
  _testState createState() => _testState();
}
var page=1;

fetchMovies() async {


  var url;
  url = await http.get(Uri.parse(
      "https://api.themoviedb.org/3/movie/popular?api_key={api_key}&language=en-US&page="+page.toString()));
  return json.decode(url.body)['results'];
}
class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(

      backgroundColor: Colors.black,
      appBar: AppBar(

        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.menu,color: Colors.red,),  //don't specify icon if you want 3 dot menu
            color: Colors.red,
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text("View Genres",style: TextStyle(color: Colors.white),)
              ),
              PopupMenuItem<int>(
                  value: 1,
                  child: Text("Randomize",style: TextStyle(color: Colors.white),)
              ),
              PopupMenuItem<int>(
                  value: 2,
                  child: Text("Popular Series",style: TextStyle(color: Colors.white),)
              ),
              PopupMenuItem<int>(
                  value: 3,
                  child: Text("Random Series",style: TextStyle(color: Colors.white),)
              ),
            ],
            onSelected: (item) => {
              if(item==0){
                print("View genres selected"),
        Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => categoryPage(),
            // Pass the arguments as part of the RouteSettings. The
            // DetailScreen reads the arguments from these settings.
           ))
              }else if (item==1){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => randomPage(),

                    ))
              }
              else if (item==2){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => popularSeries(),
                      ))
                }
                else if (item==3){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => randomSeries(),
                        ))
                  }
            },

          ),
        ],
        title:Column(
          children:<Widget> [
            SizedBox(height:10),

            Text("Popular Movies", style: TextStyle(color: Colors.red, fontSize: 20,),),
        TextField(onSubmitted: (value) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => movieSearch(),
                  // Pass the arguments as part of the RouteSettings. The
                  // DetailScreen reads the arguments from these settings.
                  settings: RouteSettings(
                    arguments: value,
                  )));

        },

          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,

              hintText: "Search Movies Here",
              hintStyle: TextStyle(color: Colors.white, )),
        ),

          ],
        ),

        elevation: 0.0,
        backgroundColor: Colors.black,
      ),

      body: FutureBuilder(
          future: fetchMovies(),
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
                                height: 210,
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

class movieSearch extends StatefulWidget {


  @override
  _movieSearchState createState() => _movieSearchState();
}

class _movieSearchState extends State<movieSearch> {
  fetchMovies(String query) async {
    var page=1;


    var url;
    url = await http.get(Uri.parse("https://api.themoviedb.org/3/search/movie?api_key={api_key}&language=en-US&page=1&include_adult=false&query="+query
    ));
    return json.decode(url.body)['results'];
  }
  @override
  Widget build(BuildContext context) {
    var movieName = ModalRoute.of(context)!.settings.arguments as String;
    fetchMovies(movieName);
   return Scaffold(

        backgroundColor: Colors.black,
        appBar: AppBar(

        centerTitle: true,
        title:Column(
        children:<Widget> [
        SizedBox(height:10),

    Text("Search Results", style: TextStyle(color: Colors.red, fontSize: 20,),),
    TextField(onSubmitted: (value) {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => movieSearch(),
    // Pass the arguments as part of the RouteSettings. The
    // DetailScreen reads the arguments from these settings.
    settings: RouteSettings(
    arguments: value,
    )));

    },

    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
    border: InputBorder.none,

    hintText: "Search Movies Here",
    hintStyle: TextStyle(color: Colors.white, )),
    ),

    ],
    ),

    elevation: 0.0,
    backgroundColor: Colors.black,
    ),

    body: FutureBuilder(
    future: fetchMovies(movieName),
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
