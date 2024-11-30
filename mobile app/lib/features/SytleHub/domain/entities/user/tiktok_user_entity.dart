import 'package:equatable/equatable.dart';

class TiktokUserEntity extends Equatable {

  final String openId;
  final String unionId;
  final String avatarUrl;
  final String avatarUrl100;
  final String avatarLargeUrl;
  final String displayName;
  final String bioDescription;
  final String profileDeepLink;
  final bool isVerified;
  final String username;
  final int followerCount;
  final int followingCount;
  final int likesCount;
  final int videoCount;

  const TiktokUserEntity({
    required this.openId,
    required this.unionId,
    required this.avatarUrl,
    required this.avatarUrl100,
    required this.avatarLargeUrl,
    required this.displayName,
    required this.bioDescription,
    required this.profileDeepLink,
    required this.isVerified,
    required this.username,
    required this.followerCount,
    required this.followingCount,
    required this.likesCount,
    required this.videoCount
  });


  @override
  List<Object> get props => [
    openId,
    unionId,
    avatarUrl,
    avatarUrl100,
    avatarLargeUrl,
    displayName,
    bioDescription,
    profileDeepLink,
    isVerified,
    username,
    followerCount,
    followingCount,
    likesCount,
    videoCount
  ];
}
