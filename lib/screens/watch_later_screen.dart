import 'package:flutflix/widgets/bottom_navigation_bar.dart';
import 'package:flutflix/widgets/watch_later_service.dart';
import 'package:flutter/material.dart';

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
// Inside the GridView.builder for movies
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of items per row
                    crossAxisSpacing: 8.0, // Spacing between items horizontally
                    mainAxisSpacing: 8.0, // Spacing between rows
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Image.network(
                          'https://image.tmdb.org/t/p/w500${snapshot.data![index]['poster_path']}',
                          fit: BoxFit.fill,
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
                                      color: Colors.white, fontSize: 16),
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline,
                                      color: Colors.red),
                                  onPressed: () async {
                                    String itemId =
                                        snapshot.data![index]['id'].toString();
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
// Inside the GridView.builder for TV shows
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of items per row
                    crossAxisSpacing: 8.0, // Spacing between items horizontally
                    mainAxisSpacing: 8.0, // Spacing between rows
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Image.network(
                          'https://image.tmdb.org/t/p/w500${snapshot.data![index]['poster_path']}',
                          fit: BoxFit.fill,
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
                                      color: Colors.white, fontSize: 16),
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline,
                                      color: Colors.red),
                                  onPressed: () async {
                                    String itemId =
                                        snapshot.data![index]['id'].toString();
                                    await WatchLaterService()
                                        .removeFromWatchLater(
                                            'watchLaterTVShows', itemId);
                                    setState(() {
                                      _tvShowsFuture = WatchLaterService()
                                          .loadWatchLater('watchLaterTVShows');
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
