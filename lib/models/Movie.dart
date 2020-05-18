class Movie {

  Movie(){

  }

  var popularity;
  int voteCount;
  bool video;
  String posterPath;
  int id;
  bool adult;
  String backdropPath;
  String originalLanguage;
  String originalTitle;
  String title;
  num voteAverage;
  String overview;
  String releaseDate;

  static Movie fromJson(json) {

    Movie m = new Movie();

    m.voteCount = json['vote_count'];
    m.video = json['video'];
    if(json['poster_path']!=null){
      m.posterPath = "http://image.tmdb.org/t/p/w500"+json['poster_path'];
    }else{
      m.posterPath = "https://afmec.org/images/no-image-available-icon.jpg";
    }
    m.id = json['id'];
    m.adult = json['adult'];
    if(json['backdrop_path']!=null){
       m.backdropPath = "http://image.tmdb.org/t/p/w500"+json['backdrop_path'];
    }else{
      m.backdropPath = "https://afmec.org/images/no-image-available-icon.jpg";
    }
   
    m.originalLanguage = json['original_language'];
    m.originalTitle = json['original_title'];
    m.title = json['title'];
    m.voteAverage = json['vote_average'];
    m.overview = json['overview'];
    m.releaseDate = json['release_date'];

    return m;
  }
}