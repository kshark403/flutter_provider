import 'package:tv/models/channelModel.dart';
import 'package:tv/models/favoriteModel.dart';

class ChannelFavoriteModel {
  ChannelFavoriteModel(this.channel, [this.favorite]);

  final ChannelModel channel;
  final FavoriteModel? favorite;
}
