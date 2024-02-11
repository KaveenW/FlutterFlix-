class Movie {
  int id;
  String title;
  String backDropPath;
  String originalTitle;
  String overview;
  String posterPath;
  String releaseDate;
  double voteAverage;
  List<String> genres;

  static final Map<int, String> genresMap = {
    28: 'Action',
    12: 'Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    14: 'Fantasy',
    36: 'History',
    27: 'Horror',
    10402: 'Music',
    9648: 'Mystery',
    10749: 'Romance',
    878: 'Science Fiction',
    10770: 'TV Movie',
    53: 'Thriller',
    10752: 'War',
    37: 'Western',
    // Add more genre mappings as needed
  };

  Movie({
    required this.id,
    required this.title,
    required this.backDropPath,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json["id"],
      title: json["title"],
      backDropPath: json["backdrop_path"],
      originalTitle: json["original_title"],
      overview: json["overview"],
      posterPath: json["poster_path"],
      releaseDate: json["release_date"],
      voteAverage: json["vote_average"].toDouble(),
      genres: _parseGenres(json['genre_ids']),
    );
  }

  String? get genre => null;

  static List<String> _parseGenres(List<dynamic>? genreIdsJson) {
    return (genreIdsJson ?? []).map((id) {
      // Convert genre ID to corresponding name using genresMap
      return genresMap[id] ?? 'Unknown';
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "backdrop_path": backDropPath,
      "original_title": originalTitle,
      "overview": overview,
      "poster_path": posterPath,
      "release_date": releaseDate,
      "vote_average": voteAverage,
      "genres": genres,
    };
  }

  get runtime => null;

  copyWith({required double voteAverage}) {}

  toMap() {}

  static Movie fromMap(Map<String, dynamic> movieMap) => Movie(
        id: movieMap['id'],
        title: movieMap['title'],
        backDropPath: movieMap['backdrop_path'],
        originalTitle: movieMap['original_title'],
        overview: movieMap['overview'],
        posterPath: movieMap['poster_path'],
        releaseDate: movieMap['release_date'],
        voteAverage: movieMap['vote_average'].toDouble(),
        genres: _parseGenres(movieMap['genre_ids']),
      );
}
