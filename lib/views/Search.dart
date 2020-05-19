import 'dart:convert';

import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:movies_app/models/Movie.dart';
import 'package:http/http.dart' as http;

import 'DetailMovie.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin<Search>{
  @override
  bool get wantKeepAlive => true;

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
  Future<List<Movie>> search(String search) async {
    var response = await http.get(
      "https://api.themoviedb.org/3/search/movie?api_key=a990cce76dfdd087f319c77744243171&language=en-US&query="+search+"&page=1",
      headers: {
         "Accept": "application/json"
       },
    );
    var listMovie;
    try {
      listMovie = (json.decode(response.body)['results'] as List);
    } catch (e) {
      print("error to list");
      print(e.toString());
    }
    return List.generate(listMovie.length, (int index) {
      return Movie.fromJson(listMovie[index]);
    });
  }
  Future<List<Movie>> searchMovie(String search) async {
    print("Text: "+search);
    var response = await http.get(
      "https://api.themoviedb.org/3/search/movie?api_key=a990cce76dfdd087f319c77744243171&language=en-US&query="+search+"&page=1",
      headers: {
         "Accept": "application/json"
       },
    );
    print(response.statusCode);
    print(response.body);
    return (json.decode(response.body)['results'] as List).map((i) => Movie.fromJson(i)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SearchBar<Movie>(
              iconActiveColor: Colors.white,
              icon: Icon(Icons.search, color: Colors.white,),
              textStyle: TextStyle(color: Colors.white),
              cancellationWidget: Text("Cancel", style: TextStyle(color: Colors.white),),
              onSearch: search,
              onItemFound: (Movie movie, int index) {
                return listItem(movie);
              },

            ),
        ),
      ),
    );
  }
}

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}