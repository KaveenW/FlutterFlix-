import 'package:flutflix/models/movie.dart';
import 'package:flutflix/models/tv_show.dart';
import 'package:flutflix/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutflix/widgets/bottom_navigation_bar.dart';
import 'package:flutflix/widgets/watch_later_service.dart';

class WatchLaterScreen extends StatefulWidget {
  @override
  _WatchLaterScreenState createState() => _WatchLaterScreenState();
}

class _WatchLaterScreenState extends State<WatchLaterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<dynamic>> _moviesFuture;
  late Future<List<dynamic>> _tvShowsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _moviesFuture = WatchLaterService().loadWatchLater('watchLaterMovies');
    _tvShowsFuture = WatchLaterService().loadWatchLater('watchLaterTVShows');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount =
        screenWidth < 600 ? 2 : 4; // Adjust based on screen width

    return Scaffold(
      appBar: AppBar(
        title: Text('Watch Later'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Movies'),
            Tab(text: 'TV Shows'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Movies tab content
          FutureBuilder<List<dynamic>>(
            future: _moviesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieScreen(
                              movie: Movie.fromJson(snapshot.data![index]),
                              tvShow: null,
                              result: null,
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Image.network(
                            'https://image.tmdb.org/t/p/w500${snapshot.data![index]['poster_path']}',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              color: Colors.black.withOpacity(0.7),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data![index]['title'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      String itemId = snapshot.data![index]
                                              ['id']
                                          .toString();
                                      await WatchLaterService()
                                          .removeFromWatchLater(
                                              'watchLaterMovies', itemId);
                                      setState(() {
                                        _moviesFuture = WatchLaterService()
                                            .loadWatchLater('watchLaterMovies');
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
          // TV Shows tab content
          FutureBuilder<List<dynamic>>(
            future: _tvShowsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieScreen(
                              movie: null,
                              tvShow: TvShow.fromJson(snapshot.data![index]),
                              result: null,
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Image.network(
                            'https://image.tmdb.org/t/p/w500${snapshot.data![index]['poster_path']}',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              color: Colors.black.withOpacity(0.7),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data![index]['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      String itemId = snapshot.data![index]
                                              ['id']
                                          .toString();
                                      await WatchLaterService()
                                          .removeFromWatchLater(
                                              'watchLaterTVShows', itemId);
                                      setState(() {
                                        _tvShowsFuture = WatchLaterService()
                                            .loadWatchLater(
                                                'watchLaterTVShows');
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}
