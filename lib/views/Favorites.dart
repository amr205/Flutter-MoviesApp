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
        constraints: new BoxConstraints.expand(
          height: 200.0,
        ),
        padding: new EdgeInsets.only(left: 0.0, bottom: 0.0, right: 0.0),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: new DecorationImage(
            image: new NetworkImage(movie.backdropPath),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: new Stack(
          children: <Widget>[
            new Positioned(
              left: 0.0,
              bottom: 0.0,
              right: 0.0,
              child: new Container(                
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(4), bottomLeft: Radius.circular(4)),
                  color: Colors.black45,
                ),
                child: 
                    new Padding(padding: EdgeInsets.all(4),
                    child: new Text(
                      movie.title,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.white,
                  ))
              ),)
            ),
          ],
        )
      ), )
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