import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WatchLaterService {
  static const _moviesKey = 'watchLaterMovies';
  static const _tvShowsKey = 'watchLaterTVShows';

  Future<void> addToWatchLater(String key, dynamic item) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> watchLaterList = prefs.getStringList(key) ?? [];
    watchLaterList.add(jsonEncode(item));
    await prefs.setStringList(key, watchLaterList);
  }

  Future<List<dynamic>> loadWatchLater(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> watchLaterList = prefs.getStringList(key) ?? [];
    return watchLaterList.map((item) => jsonDecode(item)).toList();
  }

  Future<void> removeFromWatchLater(String key, String itemId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> watchLaterList = prefs.getStringList(key) ?? [];
    watchLaterList
        .removeWhere((item) => jsonDecode(item)['id'].toString() == itemId);
    await prefs.setStringList(key, watchLaterList);
  }

  isItemAdded(String itemType, String itemId) {}
}
