// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutflix/api/api.dart';
import 'package:flutflix/constants.dart';
import 'package:flutflix/models/movie.dart';
import 'package:flutflix/models/tv_show.dart';
import 'package:flutflix/widgets/bottom_navigation_bar.dart';
import 'package:flutflix/widgets/back_button.dart';
import 'package:flutflix/widgets/movie_page_buttons.dart';
import 'package:flutflix/widgets/rating_star.dart';
import 'package:flutflix/widgets/recommendationWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieScreen extends StatefulWidget {
  final Movie? movie;
  final TvShow? tvShow;
  final dynamic result;

  const MovieScreen({
    Key? key,
    required this.movie,
    required this.tvShow,
    required this.result,
  }) : super(key: key);

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  bool isExpanded = false;

  void _addToWatchLater() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key =
        widget.movie != null ? 'watchLaterMovies' : 'watchLaterTVShows';
    List<String> watchLaterList = prefs.getStringList(key) ?? [];
    watchLaterList.add(jsonEncode(widget.movie ?? widget.tvShow));
    await prefs.setStringList(key, watchLaterList);
  }

  void _addToWatched() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = widget.movie != null
        ? 'watchedMovies'
        : 'watchedTVShows'; // Adjusted key based on the type of content
    List<String> watchedList = prefs.getStringList(key) ?? [];
    watchedList.add(jsonEncode(widget.movie ?? widget.tvShow));
    await prefs.setStringList(key, watchedList);
  }

  Future<List<dynamic>> _fetchRecommendations() async {
    try {
      if (widget.movie != null) {
        return await Api().getMovieRecommendations(widget.movie!.id);
      } else if (widget.tvShow != null) {
        return await Api().getTvShowRecommendations(widget.tvShow!.id);
      } else {
        return []; // Return an empty list if neither movie nor tvShow is provided
      }
    } catch (e) {
      throw Exception('Failed to fetch recommendations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String overview =
        widget.movie?.overview ?? widget.tvShow?.overview ?? 'N/A';
    String truncatedOverview =
        overview.length > 150 ? overview.substring(0, 150) + '...' : overview;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Opacity(
              opacity: 0.4,
              child: Image.network(
                '${Constants.imagePath}${widget.movie?.backDropPath ?? widget.tvShow?.backdropPath}',
                width: double.infinity,
                height: 260,
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: BackButton(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 170,
                        ),
                        MoviePageButtons(
                          onAddPressed: _addToWatchLater,
                          onWatchedPressed: _addToWatched,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 60),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              '${Constants.imagePath}${widget.movie?.posterPath ?? widget.tvShow?.posterPath}',
                              height: 250,
                              width: 150,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 110, right: 60),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text(
                                'Release Date: ${widget.movie?.releaseDate ?? widget.tvShow?.firstAirDate ?? 'N/A'}',
                                style: TextStyle(
                                  fontSize: 16, // Reduced font size
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Rating: ',
                                    style: TextStyle(
                                      fontSize: 16, // Reduced font size
                                      color: Colors.white,
                                    ),
                                  ),
                                  RatingStars(
                                    rating: widget.movie?.voteAverage ??
                                        widget.tvShow?.voteAverage ??
                                        0,
                                    starSize: 16,
                                    color: Colors.yellow,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Genres:',
                        style: TextStyle(
                          fontSize: 16, // Reduced font size
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var genre in widget.movie?.genres ??
                                widget.tvShow?.genres ??
                                [])
                              Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Chip(
                                  label: Text(
                                    genre,
                                    style: TextStyle(
                                      fontSize: 12, // Reduced font size
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Column(
                      children: [
                        Text(
                          widget.movie?.title ?? widget.tvShow?.name ?? 'N/A',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: Text(
                            isExpanded ? overview : truncatedOverview,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        SizedBox(height: 10),
                        if (!isExpanded)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isExpanded = true;
                              });
                            },
                            child: Text(
                              'See more',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        if (isExpanded)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isExpanded = false;
                              });
                            },
                            child: Text(
                              'See less',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: FutureBuilder<List<dynamic>>(
                      future: _fetchRecommendations(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final recommendations = snapshot.data ?? [];
                          return RecommendationWidget(
                            recommendations: recommendations,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}
