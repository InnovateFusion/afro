import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/product.dart';

class ShareProductToTiktokUseCase
    extends UseCase<void, ShareProductToTiktokParams> {
  final ProductRepository repository;

  ShareProductToTiktokUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ShareProductToTiktokParams params) async {
    return await repository.shareProductToTikTok(
        accessToken: params.accessToken,
        title: params.title,
        description: params.description,
        disableComments: params.disableComments,
        stitchDisabled: params.stitchDisabled,
        duetDisabled: params.duetDisabled,
        privcayLevel: params.privcayLevel,
        autoAddMusic: params.autoAddMusic,
        source: params.source,
        photoCoverIndex: params.photoCoverIndex,
        photoImages: params.photoImages,
        postMode: params.postMode,
        mediaType: params.mediaType,
        brandContentToggle: params.brandContentToggle,
        brandOrganicToggle: params.brandOrganicToggle);
  }
}

class ShareProductToTiktokParams extends Equatable {
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

  const ShareProductToTiktokParams(
      {required this.accessToken,
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
      required this.brandOrganicToggle});

  @override
  List<Object> get props => [
        accessToken,
        title,
        description,
        disableComments,
        duetDisabled,
        stitchDisabled,
        privcayLevel,
        autoAddMusic,
        source,
        photoCoverIndex,
        photoImages,
        postMode,
        mediaType,
        brandContentToggle,
        brandOrganicToggle
      ];
}
