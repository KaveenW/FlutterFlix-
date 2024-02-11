class TvShow {
  int id;
  String name;
  String backdropPath;
  String originalName;
  String overview;
  String posterPath;
  String firstAirDate;
  double voteAverage;
  List<String> genres;
  String status;

  TvShow({
    required this.id,
    required this.name,
    required this.backdropPath,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.firstAirDate,
    required this.voteAverage,
    required this.genres,
    required this.status,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      id: json["id"],
      name: json["name"] ?? "",
      backdropPath: json["backdrop_path"] ?? "",
      originalName: json["original_name"] ?? "",
      overview: json["overview"] ?? "",
      posterPath: json["poster_path"] ?? "",
      firstAirDate: json["first_air_date"] ?? "",
      voteAverage: (json["vote_average"] as num?)?.toDouble() ?? 0.0,
      genres: _parseGenres(json['genre_ids']),
      status: json['status'] ?? "",
    );
  }

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

  static List<String> _parseGenres(List<dynamic>? genreIdsJson) {
    // Assuming genreIdsJson contains integers
    final List<int> genreIds = List<int>.from(genreIdsJson ?? []);
    return genreIds.map((id) {
      // Map genre ID to genre name using a predefined genresMap
      return genresMap[id] ?? 'Unknown';
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "backdrop_path": backdropPath,
      "original_name": originalName,
      "overview": overview,
      "poster_path": posterPath,
      "first_air_date": firstAirDate,
      "vote_average": voteAverage,
      "genres": genres, // Include genres in JSON output
      "status": status, // Include status in JSON output
    };
  }

  copyWith({required double voteAverage}) {
    return TvShow(
      id: id,
      name: name,
      backdropPath: backdropPath,
      originalName: originalName,
      overview: overview,
      posterPath: posterPath,
      firstAirDate: firstAirDate,
      voteAverage: voteAverage,
      genres: genres, // Include genres in copied object
      status: status, // Include status in copied object
    );
  }
}
