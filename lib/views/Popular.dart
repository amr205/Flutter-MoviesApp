import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movies_app/models/Movie.dart';
import 'package:movies_app/models/MyDatabase.dart';
import 'package:movies_app/views/DetailMovie.dart';

class Popular extends StatefulWidget {
  @override
  _PopularState createState() => _PopularState();
}

class _PopularState extends State<Popular> with AutomaticKeepAliveClientMixin<Popular> {
  int pageNum = 2;
  bool isLoading =false;
  List<Movie> listMovies;
  bool internetAvailable = true;

  Future<String> getMoreData() async{
   try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await http.get(
          "https://api.themoviedb.org/3/movie/popular?api_key=a990cce76dfdd087f319c77744243171&page="+pageNum.toString(),
          headers: {
            "Accept": "application/json"
          },
        );
        
        this.setState((){
          isLoading=false;
          pageNum++;
          var newlistMovies=(json.decode(response.body)['results'] as List).map((i) => Movie.fromJson(i)).toList();
          listMovies.addAll(newlistMovies);
        });
        
        return "success";
      }
    } on SocketException catch (_) {
      return "success";
    }
    return "success";
    
  }
  Future<String> getMovies() async{
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
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
            internetAvailable = true;
          });
           MyDatabase myDB = new MyDatabase();
           await myDB.init();
           await myDB.savePopular(listMovies);
           await myDB.closeDatabase();
          return "success";
        }
      } on SocketException catch (_) {
          this.setState((){
            internetAvailable = false;
            isLoading=true;
          });
          MyDatabase myDB = new MyDatabase();
          await myDB.init();
          var myLocalList = await myDB.getPopular();
          this.setState((){
            isLoading=false;
            listMovies=myLocalList;
          });
          await myDB.closeDatabase();
          return "success";
      }
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
            image: internetAvailable? new NetworkImage(movie.backdropPath):  AssetImage("assets/images/placeholder.jpg"),
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
        elevation: 0.0,
        title: Text('Popular Movies'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: isLoading ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff48d6b4)), )): 
          RefreshIndicator(
            child: 
            ListView.builder(
              itemCount: listMovies == null ? 0 : listMovies.length+1,
              itemBuilder: (BuildContext context, int index){
                if(index< listMovies.length){
                  return listItem(listMovies[index]);
                }else{
                  getMoreData();
                  return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff48d6b4)),));
                }
              } 
            ),
              onRefresh: getMovies,)
            
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
