import 'dart:convert';
import 'package:flutflix/constants.dart';
import 'package:flutflix/models/movie.dart';
import 'package:flutflix/models/tv_show.dart';
import 'package:http/http.dart' as http;

class Api {
  static const _trendingUrl =
      'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constants.apiKey}';
  static const _topRatedUrl =
      'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}';
  static const _onCinemaUrl =
      'https://api.themoviedb.org/3/movie/now_playing?api_key=${Constants.apiKey}';
  static const _multiUrl =
      'https://api.themoviedb.org/3/search/multi?api_key=${Constants.apiKey}';
  static const _onTheAirUrl =
      'https://api.themoviedb.org/3/tv/airing_today?api_key=${Constants.apiKey}';
  static const _familyFriendlyMovies =
      'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}&sort_by=revenue.desc&adult=false&with_genres=16';
  static const _movieRecommendations =
      'https://api.themoviedb.org/3/movie/{movie_id}/recommendations?api_key=${Constants.apiKey}';
  static const _tvShowRecommendations =
      'https://api.themoviedb.org/3/tv/{series_id}/recommendations?api_key=${Constants.apiKey}';

  Future<List<Movie>> getTrendingMovies() async {
    final response = await http.get(Uri.parse(_trendingUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(_topRatedUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<Movie>> getOnCinema() async {
    final response = await http.get(Uri.parse(_onCinemaUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<Movie>> getMulti() async {
    final response = await http.get(Uri.parse(_multiUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;

      // Filter only movies from the multi search results
      final movies = decodedData
          .where((result) => result['media_type'] == 'movie')
          .toList();

      return movies.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<TvShow>> getOnTheAir() async {
    final response = await http.get(Uri.parse(_onTheAirUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((tvShow) => TvShow.fromJson(tvShow)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<Movie>> getFamilyFriendlyMovies() async {
    final response = await http.get(Uri.parse(_familyFriendlyMovies));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<Movie>> getMovieRecommendations(int movieId) async {
    final String url =
        _movieRecommendations.replaceFirst('{movie_id}', movieId.toString());
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  Future<List<TvShow>> getTvShowRecommendations(int tvShowId) async {
    final String url =
        _tvShowRecommendations.replaceFirst('{series_id}', tvShowId.toString());
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body)['results'] as List;
        return decodedData.map((tvShow) => TvShow.fromJson(tvShow)).toList();
      } else {
        throw Exception(
            'Failed to load TV show recommendations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting TV show recommendations: $e');
      throw Exception('Failed to load TV show recommendations');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final searchUrl =
        'https://api.themoviedb.org/3/search/multi?api_key=${Constants.apiKey}&query=$query';
    final response = await http.get(Uri.parse(searchUrl));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }
}
