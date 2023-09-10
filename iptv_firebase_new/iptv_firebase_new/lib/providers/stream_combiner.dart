import 'package:tv/app.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/models/SectionModel.dart';
import 'package:tv/models/channelModel.dart';
import 'package:tv/models/channel_favorite_model.dart';
import 'package:tv/models/favoriteModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tv/models/favorite_section_model.dart';
import 'package:tv/models/section_channel_model.dart';
import 'package:tv/utils/utils.dart';

class StreamCombiner {
  Stream<List<ChannelFavoriteModel>> getCombineChannelFavoriteStreams(
      sectionuid) {
    Stream<List<ChannelModel>?> stream1;
    Stream<List<FavoriteModel>?> stream2;

    if (isFirebaseDown) {
      stream1 = channelProvider.onChannelModels(sectionuid);
      stream2 = favoriteProvider.onFavoritesBySectionUid(sectionuid);
    } else {
      stream1 = FirebaseManager.shared.getchannelByStatus(channel: sectionuid);
      stream2 = FirebaseManager.shared
          .getMyFavoritesBySectionUid(sectionUid: sectionuid);
    }

    return CombineLatestStream.combine2(stream1, stream2,
        (channels, favorites) {
      List<ChannelFavoriteModel> listChannelFavorite =
          (channels as List<ChannelModel>).map((channel) {
        try {
          final favorite = (favorites as List<FavoriteModel>).firstWhere(
            (element) => element.channelId == channel.uid,
            // orElse: () => null
          );
          return ChannelFavoriteModel(channel, favorite);
        } catch (e) {
          return ChannelFavoriteModel(channel);
        }
      }).toList();
      return listChannelFavorite;
    });
  }

  Stream<List<FavoriteSectionModel>> getCombineFavoriteSectionStreams(
      sectionType) {
    Stream<List<FavoriteModel>?> stream1;
    Stream<List<SectionModel>?> stream2;

    if (isFirebaseDown) {
      stream1 = favoriteProvider.onFavorites(sectionType);
      stream2 = sectionProvider.onSections(sectionType);
    } else {
      stream1 = FirebaseManager.shared.getMyFavorites(section: sectionType);
      stream2 = FirebaseManager.shared.getSectionBySectionType(sectionType);
    }

    return CombineLatestStream.combine2(stream1, stream2,
        (favorites, sections) {
      List<FavoriteSectionModel> listFavoriteSection =
          (favorites as List<FavoriteModel>).map((favorite) {
        try {
          final section = (sections as List<SectionModel>).firstWhere(
            (element) => element.uid == favorite.sectionUid,
            // orElse: () => null
          );
          return FavoriteSectionModel(favorite, section);
        } catch (e) {
          return FavoriteSectionModel(favorite);
        }
      }).toList();
      return listFavoriteSection;
    });
  }

  Stream<List<SectionChannelModel>> getCombineSectionChannelStreams(
      sectionType) {
    Stream<List<SectionModel>?> stream1;
    Stream<List<ChannelModel>?> stream2;

    if (isFirebaseDown) {
      stream1 = sectionProvider.onSections(sectionType);
      stream2 = channelProvider.onChannelModelsBySectionType(sectionType);
    } else {
      stream1 = FirebaseManager.shared.getSectionBySectionType(sectionType);
      stream2 = FirebaseManager.shared
          .getchannelBySectionType(sectionType: sectionType);
    }

    return CombineLatestStream.combine2(stream1, stream2, (sections, channels) {
      List<SectionChannelModel> listSectionChannel =
          (sections as List<SectionModel>).map((section) {
        int total = 0;
        try {
          final List channel = (channels as List<ChannelModel>);

          for (ChannelModel ch in channel) {
            if (ch.sectionuid == section.uid) {
              total++;
            }
          }
          return SectionChannelModel(section, total);
        } catch (e) {
          // print("error here " + e.toString());
          return SectionChannelModel(section, total);
        }
      }).toList();
      return listSectionChannel;
    });
  }
}
