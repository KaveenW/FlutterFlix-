import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WatchedService {
  static const _moviesKey = 'watchedMovies';
  static const _tvShowsKey = 'watchedTVShows';

  Future<void> addToWatched(String key, dynamic item) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> watchedList = prefs.getStringList(key) ?? [];
    watchedList.add(jsonEncode(item));
    await prefs.setStringList(key, watchedList);
  }

  Future<List<dynamic>> loadWatched(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> watchedList = prefs.getStringList(key) ?? [];
    return watchedList.map((item) => jsonDecode(item)).toList();
  }

  Future<void> removeFromWatched(String key, String itemId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> watchedList = prefs.getStringList(key) ?? [];
    watchedList
        .removeWhere((item) => jsonDecode(item)['id'].toString() == itemId);
    await prefs.setStringList(key, watchedList);
  }

  isItemAdded(String itemType, String itemId) {}
}
