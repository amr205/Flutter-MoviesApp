import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movies_app/models/Cast.dart';
import 'package:movies_app/models/Movie.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailMovie extends StatefulWidget {
  final Movie movie;
  const DetailMovie ({ Key key, this.movie }): super(key: key);

  @override
  _DetailMovieState createState() => _DetailMovieState();
}

class _DetailMovieState extends State<DetailMovie> {

  var videoLoaded = false;
  var isFavorite = false;
  List<Cast> listCast;
  final _scaffoldKey = GlobalKey<ScaffoldState>(); 

  YoutubePlayerController _controller = null;

  void initData(){
    checkFavoriteStatus();
    getVideos();
    getCast();
  }
  Future<String> getVideos() async{
      var response = await http.get(
        "https://api.themoviedb.org/3/movie/"+widget.movie.id.toString()+"/videos?api_key=a990cce76dfdd087f319c77744243171",
        headers: {
          "Accept": "application/json"
        },
      );
      try{
        this.setState((){
          videoLoaded=true;
          var videoKey =json.decode(response.body)['results'][0]['key'];
          _controller = YoutubePlayerController(
            initialVideoId: videoKey,
            flags: YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
            ),
          );
        });
      }catch(e){
        print("video not found");
      }
      
      
      return "success";
  }

  Future<String> checkFavoriteStatus() async{
      var response = await http.get(
        "https://api.themoviedb.org/3/list/142655/item_status?api_key=a990cce76dfdd087f319c77744243171&movie_id="+widget.movie.id.toString(),
        headers: {
          "Accept": "application/json"
        },
      );
      
      this.setState((){
        isFavorite=json.decode(response.body)['item_present'];
      });
      
      return "success";
  }

  Future<String> getCast() async{
      var response = await http.get(
        "https://api.themoviedb.org/3/movie/"+widget.movie.id.toString()+"/credits?api_key=a990cce76dfdd087f319c77744243171",
        headers: {
          "Accept": "application/json"
        },
      );
      
      this.setState((){
        listCast=(json.decode(response.body)['cast'] as List).map((i) => Cast.fromJson(i)).toList();
      });
      
      return "success";
  }

  Future<String> addToFavorites() async{
     Map<String, String> header = {"Content-type":"application/json"};
     String cadJson = '{"media_id":"'+widget.movie.id.toString()+'"}';

     var response = await http.post(
      "https://api.themoviedb.org/3/list/142655/add_item?api_key=a990cce76dfdd087f319c77744243171&session_id=8287094726b4b87b039e884164a7d8d7c3c186c5",
      headers: header,
      body: cadJson
     );

    this.setState((){
      isFavorite=true;
    });
 
    
    return "success";
  }

  Future<String> removeFromFavorites() async{
     Map<String, String> header = {"Content-type":"application/json"};
     String cadJson = '{"media_id":"'+widget.movie.id.toString()+'"}';

     var response = await http.post(
      "https://api.themoviedb.org/3/list/142655/remove_item?api_key=a990cce76dfdd087f319c77744243171&session_id=8287094726b4b87b039e884164a7d8d7c3c186c5",
      headers: header,
      body: cadJson
     );

    this.setState((){
      isFavorite=false;
    });
 
    
    return "success";
  }


  @override
  Widget build(BuildContext context) {

    Widget showVideo(){
      if(videoLoaded){
        if(_controller==null){
          return Text("No video available");
        }else{
          return YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          );
        }
        
      }else{
        return Center(child: CircularProgressIndicator());
      }
    }

    Widget overViewTitle = Container(
                      color: Color.fromRGBO(64, 75, 96, .9),
                      height: 35,
                      child:  Padding(padding: EdgeInsets.only(left:15),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.local_movies,
                              color: Colors.white70,
                              size: 20.0,
                            ),
                            Expanded(
                              child: Padding(padding: EdgeInsets.only(left:15),
                                child:Text('Overview', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 19),),
                              )
                            )
                          ],
                        ),
                      )
                    );

    Widget castTitle = Container(
                      color: Color.fromRGBO(64, 75, 96, .9),
                      height: 35,
                      child:  Padding(padding: EdgeInsets.only(left:15),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.person,
                              color: Colors.white70,
                              size: 20.0,
                            ),
                            Expanded(
                              child: Padding(padding: EdgeInsets.only(left:15),
                                child:Text('Cast', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 19),),
                              )
                            )
                          ],
                        ),
                      )
                    );

    Widget castImage(cast){
      return new Center(
            child: Padding(padding: EdgeInsets.only(left:10, top: 9),
            child:new Column(
              children: <Widget>[
                new Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Color.fromRGBO(64, 75, 96, .9),
                          width: 3.0,
                        ),
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                              cast.profilePath
                            )
                        )
                    )),
                Container(width: 80,
                          height: 20,
                 child: new Text(cast.name, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(color: Colors.white70),)
                 )
              ],
            )));
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      key: _scaffoldKey, 
      appBar: AppBar(
        title: Text(widget.movie.title),
        actions: <Widget>[
        IconButton(
          icon: isFavorite? Icon(
            Icons.star,
            color: Color(0xff00d573),
          ) :
          Icon(
            Icons.star_border,
            color: Color(0xff48d6b4),
          ),
          onPressed: () {
            if(isFavorite){
              removeFromFavorites();
              final snackBar = SnackBar(content: Text('This movie was removed from favorites'),duration:Duration(seconds: 1));
              // Find the Scaffold in the widget tree and use it to show a SnackBar.
              _scaffoldKey.currentState.showSnackBar(snackBar);
            }else{
              addToFavorites();
              final snackBar = SnackBar(content: Text('This movie was added to favorites'),duration:Duration(seconds: 1),);
              // Find the Scaffold in the widget tree and use it to show a SnackBar.
              _scaffoldKey.currentState.showSnackBar(snackBar);
            }
          },
        )
        ]
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          showVideo(),
          Expanded(
              child: Container(
                color: Color.fromRGBO(58, 66, 86, 1.0),
                child: ListView(
                  children: <Widget>[
                    overViewTitle,
                    Wrap(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(8),
                      child: Text(widget.movie.overview, 
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          maxLines: 12,
                          overflow: TextOverflow.visible,
                        )
                      ),
                      ],
                    ),
                    castTitle,
                    listCast==null ? Center(child: CircularProgressIndicator()): 
                    Container(
                      height: 100,
                      color: Color.fromRGBO(58, 66, 86, 1.0),
                      child: 
                      Scrollbar( 
                        child: ListView.builder(
                            itemCount: listCast == null ? 0 : listCast.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index){
                              return castImage(listCast[index]);
                            } 
                          ),
                        )
                      ) 
                    ]
                  ),
              ),
            ),
        ],
      )
    );
  }

  @override
    void initState() {
      super.initState();
      WidgetsBinding.instance
          .addPostFrameCallback((_) => initData());

    }
}