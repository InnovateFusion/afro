part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class GetColorsEvent extends ProductEvent {
  GetColorsEvent();
}

class GetSizesEvent extends ProductEvent {
  GetSizesEvent();
}

class GetCategoriesEvent extends ProductEvent {
  GetCategoriesEvent();
}

class GetBrandsEvent extends ProductEvent {
  GetBrandsEvent();
}

class GetMaterialsEvent extends ProductEvent {
  GetMaterialsEvent();
}

class GetLocationsEvent extends ProductEvent {
  GetLocationsEvent();
}

class GetDesignsEvent extends ProductEvent {
  GetDesignsEvent();
}

class GetDomainsEvent extends ProductEvent {
  GetDomainsEvent();
}

class ResetMyPasswordEvent extends ProductEvent {
  final String oldPassword;
  final String newPassword;
  final String token;

  ResetMyPasswordEvent({
    required this.oldPassword,
    required this.newPassword,
    required this.token,
  });
}

class SearchProductEvent extends ProductEvent {
  final String query;
  final String token;

  SearchProductEvent({
    required this.query,
    required this.token,
  });
}

class ShareProductToTiktokEvent extends ProductEvent {
   final String accessToken;
  final String title;
  final String description;
  final bool disableComments;
  final bool duetDisabled;
  final bool stitchDisabled;
  final String privcayLevel;
  final bool autoAddMusic;
  final String source;
  final int photoCoverIndex;
  final List<String> photoImages;
  final String postMode;
  final String mediaType;
  final bool brandContentToggle;
  final bool brandOrganicToggle;

  ShareProductToTiktokEvent({
    required this.accessToken,
    required this.title,
    required this.description,
    required this.disableComments,
    required this.duetDisabled,
    required this.stitchDisabled,
    required this.privcayLevel,
    required this.autoAddMusic,
    required this.source,
    required this.photoCoverIndex,
    required this.photoImages,
    required this.postMode,
    required this.mediaType,
    required this.brandContentToggle,
    required this.brandOrganicToggle,
  });
}

class RemoveBackgroundEvent extends ProductEvent {
  final String token;
  final File image;

  RemoveBackgroundEvent({
    required this.token,
    required this.image,
  });
}

class ResetBackgroundRemoverEvent extends ProductEvent {
  ResetBackgroundRemoverEvent();
}

class RemoveBackgroundFromUrlEvent extends ProductEvent {
  final String token;
  final String imageUrl;

  RemoveBackgroundFromUrlEvent({
    required this.token,
    required this.imageUrl,
  });
}