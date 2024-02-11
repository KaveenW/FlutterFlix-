import 'package:flutflix/api/api.dart';
import 'package:flutflix/models/tv_show.dart';
import 'package:flutflix/widgets/movies_slider.dart';
import 'package:flutflix/widgets/trending_slider.dart';
import 'package:flutflix/widgets/tvShow_Slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/movie.dart';
// Import the custom bottom navigation bar

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> topRatedMovies;
  late Future<List<Movie>> onCinema;
  late Future<List<TvShow>> onTheAir;
  late Future<List<Movie>> familyFriendlyMovies;
  int currentIndex = 0; // Keep track of the current index for the bottom bar

  @override
  void initState() {
    super.initState();
    trendingMovies = Api().getTrendingMovies();
    topRatedMovies = Api().getTopRatedMovies();
    onCinema = Api().getOnCinema();
    onTheAir = Api().getOnTheAir();
    familyFriendlyMovies = Api().getFamilyFriendlyMovies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent going back when on the home screen
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Image.asset(
            'assets/flutflix.png',
            fit: BoxFit.cover,
            height: 40,
            filterQuality: FilterQuality.high,
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 0, 0, 0),
                Color.fromARGB(255, 0, 0, 0),
              ],
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Trending Movies',
                      style: GoogleFonts.aBeeZee(fontSize: 25),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    child: FutureBuilder(
                      future: trendingMovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          return TrendingSlider(
                            snapshot: snapshot,
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      'Top rated movies',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    child: FutureBuilder(
                      future: topRatedMovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          return MoviesSlider(
                            snapshot: snapshot,
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      "What's on at the Cinema ",
                      style: GoogleFonts.aBeeZee(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    child: FutureBuilder(
                      future: onCinema,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          return MoviesSlider(
                            snapshot: snapshot,
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      "What's on TV tonight",
                      style: GoogleFonts.aBeeZee(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    child: FutureBuilder<List<TvShow>>(
                      future: onTheAir,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          return TvShowSlider(
                            snapshot: snapshot,
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      'Family Friendly Movies',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    child: FutureBuilder(
                      future: familyFriendlyMovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          return MoviesSlider(
                            snapshot: snapshot,
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
