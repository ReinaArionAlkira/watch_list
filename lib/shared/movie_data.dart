enum MovieStatus {
  planned("planned"),
  watching("watching"),
  watched("watched");

  const MovieStatus(this.value);

  final String value;
}

class MovieData {
  String? id;
  late String title;
  late MovieStatus status;
  late int score;

  MovieData({required this.title, required this.status, required this.score});

  Map<String, dynamic> toMap() {
    return {"title": title, "status": status.value, "score": score};
  }

  factory MovieData.fromMap(Map<String, dynamic> map, String? id) {
    var movie = MovieData(
        title: map["title"],
        status: MovieStatus.values
            .firstWhere((element) => element.value == map["status"]),
        score: map["score"]);
    if (id != null) {
      movie.id = id;
    }
    return movie;
  }
}
