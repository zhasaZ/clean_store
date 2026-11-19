import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../../models/product_model.dart';

abstract class FavoritesLocalDataSource {
  Future<List<ProductModel>> getFavorites();
  Future<void> saveFavorites(List<ProductModel> products);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final SharedPreferences prefs;

  FavoritesLocalDataSourceImpl(this.prefs);

  @override
  Future<List<ProductModel>> getFavorites() async {
    try {
      final raw = prefs.getString(StorageKeys.favorites);
      if (raw == null) return [];
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      throw const CacheException();
    }
  }

  @override
  Future<void> saveFavorites(List<ProductModel> products) async {
    try {
      final raw = jsonEncode(products.map((e) => e.toJson()).toList());
      final ok = await prefs.setString(StorageKeys.favorites, raw);
      if (!ok) throw const CacheException();
    } catch (_) {
      throw const CacheException();
    }
  }
}
