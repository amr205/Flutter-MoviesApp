import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movies_app/models/Movie.dart';
import 'package:movies_app/views/DetailMovie.dart';

class Popular extends StatefulWidget {
  @override
  _PopularState createState() => _PopularState();
}

class _PopularState extends State<Popular> {

  bool isLoading =false;
  List<Movie> listMovies;

  Future<String> getMovies() async{
    this.setState((){
      isLoading=true;
    });
    var response = await http.get(
      "https://api.themoviedb.org/3/movie/popular?api_key=a990cce76dfdd087f319c77744243171",
      headers: {
         "Accept": "application/json"
       },
    );
    
    this.setState((){
      isLoading=false;
      listMovies=(json.decode(response.body)['results'] as List).map((i) => Movie.fromJson(i)).toList();
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
        elevation: 0.0,
        title: Text('Popular Movies'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: isLoading ? Center(child: CircularProgressIndicator()): 
            ListView.builder(
              itemCount: listMovies == null ? 0 : listMovies.length,
              itemBuilder: (BuildContext context, int index){
                return listItem(listMovies[index]);
              } 
            ),
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