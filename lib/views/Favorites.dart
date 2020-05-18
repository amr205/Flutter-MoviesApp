import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movies_app/models/Movie.dart';
import 'package:http/http.dart' as http;

import 'DetailMovie.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  bool isLoading =false;
  List<Movie> listMovies;

  Future<String> getMovies() async{
    this.setState((){
      isLoading=true;
    });
    var response = await http.get(
      "https://api.themoviedb.org/3/list/142655?api_key=a990cce76dfdd087f319c77744243171&language=en-US",
      headers: {
         "Accept": "application/json"
       },
    );
    
    this.setState((){
      isLoading=false;
      listMovies=(json.decode(response.body)['items'] as List).map((i) => Movie.fromJson(i)).toList();
    });
    
    return "success";
  }

  Widget listItem(movie){
    return new GestureDetector(
      onTap: ()=>{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailMovie(movie: movie))
        )
      },
      child: Card(
        child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: Padding(
              padding: EdgeInsets.all(4.0),
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.network(
                    movie.backdropPath,
                  ),
                  Text(movie.title,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white))
                ]
              ),
              ),
            )
      )
    );  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Favorites'),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: isLoading ? Center(child: CircularProgressIndicator()): 
            RefreshIndicator(
              child: ListView.builder(
                itemCount: listMovies == null ? 0 : listMovies.length,
                itemBuilder: (BuildContext context, int index){
                  return listItem(listMovies[index]);
                } 
              ),
              onRefresh: getMovies,
            )
        )
      )
    );
  }

   @override
    void initState() {
      super.initState();
      WidgetsBinding.instance
          .addPostFrameCallback((_) => getMovies());

    }
}