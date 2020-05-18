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

class _SearchState extends State<Search> {
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