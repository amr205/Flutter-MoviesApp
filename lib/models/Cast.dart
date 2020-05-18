class Cast {

  Cast(){

  }

  int id;
  String character;
  int gender;
  String name;
  String profilePath;

  static Cast fromJson(json) {

    Cast m = new Cast();

    m.id = json['cast_id'];
    m.character = json['character'];

    if(json['profile_path']!=null)
      m.profilePath = "http://image.tmdb.org/t/p/w500"+json['profile_path'];
    else
      m.profilePath = "https://continentalenvelope.com/wp-content/uploads/2019/09/user-icon.png";

    m.gender = json['gender'];
    m.name = json['name'];

    return m;
  }
}