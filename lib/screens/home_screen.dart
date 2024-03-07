import 'package:flutflix/api/api.dart';
import 'package:flutflix/models/movie.dart';
import 'package:flutflix/models/tv_show.dart';
import 'package:flutflix/screens/details_screen.dart';
import 'package:flutflix/screens/search_screen.dart';
import 'package:flutflix/widgets/bottom_navigation_bar.dart';
import 'package:flutflix/widgets/movies_slider.dart';
import 'package:flutflix/widgets/trending_slider.dart';
import 'package:flutflix/widgets/tvShow_Slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  int currentIndex = 0;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    trendingMovies = Api().getTrendingMovies();
    topRatedMovies = Api().getTopRatedMovies();
    onCinema = Api().getOnCinema();
    onTheAir = Api().getOnTheAir();
    familyFriendlyMovies = Api().getFamilyFriendlyMovies();

    // Add listener to Connectivity stream
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'FlutterFlix',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: const Color.fromARGB(255, 192, 51, 51),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
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
              FutureBuilder(
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
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Higgest Grossing',
                  style: GoogleFonts.aBeeZee(
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder(
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
                    return const Center(child: CircularProgressIndicator());
                  }
                },
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
              FutureBuilder(
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
                    return const Center(child: CircularProgressIndicator());
                  }
                },
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
              FutureBuilder<List<TvShow>>(
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
                    return const Center(child: CircularProgressIndicator());
                  }
                },
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
              FutureBuilder(
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
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            if (currentIndex == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            }
          });
        },
      ),
    );
  }
}
