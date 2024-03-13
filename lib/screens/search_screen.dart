import 'dart:async';
import 'package:flutflix/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';
import 'details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchSearchResults(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isLoading = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/multi?api_key=${Constants.apiKey}&query=$query'));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);

      // Filter results to include only movies and TV shows
      final filteredResults = jsonBody['results'].where((result) {
        final mediaType = result['media_type'];
        return mediaType == 'movie' || mediaType == 'tv';
      }).toList();

      setState(() {
        _isLoading = false;
        _searchResults = filteredResults;
      });
    } else {
      setState(() {
        _isLoading = false;
        _searchResults = [];
      });
    }
  }

  void _onSearchTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchSearchResults(text);
    });
  }

  void _navigateToDetailsScreen(dynamic result) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          if (result['media_type'] == 'movie') {
            return MovieScreen(
              movie: Movie.fromJson(result),
              result: null,
              tvShow: null,
            );
          } else if (result['media_type'] == 'tv') {
            return MovieScreen(
              movie: null,
              result: null,
              tvShow: TvShow.fromJson(result),
            );
          } else {
            return MovieScreen(
              movie: null,
              result: result,
              tvShow: null,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount =
        screenWidth < 600 ? 2 : 4; // Adjust based on screen width

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _onSearchTextChanged,
          decoration: const InputDecoration(
            hintText: 'Search for a movie...',
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isNotEmpty
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final result = _searchResults[index];
                    return InkWell(
                      onTap: () => _navigateToDetailsScreen(result),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Image.network(
                                _getImageUrl(result),
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.movie);
                                },
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                result['title'] ?? result['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text('No results found'),
                ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }

  String _getImageUrl(dynamic result) {
    // Determine media type and construct the appropriate image URL
    final mediaType = result['media_type'];
    final posterPath = result['poster_path'];

    if (mediaType == 'movie' || mediaType == 'tv') {
      return 'https://image.tmdb.org/t/p/w500$posterPath';
    } else if (mediaType == 'person') {
      return 'https://image.tmdb.org/t/p/w500${result['profile_path']}';
    } else {
      // Add more cases if needed for other media types
      return ''; // Empty URL if no match
    }
  }
}
