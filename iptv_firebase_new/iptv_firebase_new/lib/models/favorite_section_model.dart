import 'package:tv/models/SectionModel.dart';
import 'package:tv/models/favoriteModel.dart';

class FavoriteSectionModel {
  FavoriteSectionModel(this.favorite, [this.section]);

  final FavoriteModel favorite;
  final SectionModel? section;
}
