import '../../../domain/entities/user/tiktok_user_entity.dart';

class TiktokUserModel extends TiktokUserEntity {
  const TiktokUserModel(
      {required super.openId,
      required super.unionId,
      required super.avatarUrl,
      required super.avatarUrl100,
      required super.avatarLargeUrl,
      required super.displayName,
      required super.bioDescription,
      required super.profileDeepLink,
      required super.isVerified,
      required super.username,
      required super.followerCount,
      required super.followingCount,
      required super.likesCount,
      required super.videoCount});

  factory TiktokUserModel.fromJson(Map<String, dynamic> json) {
    return TiktokUserModel(
        openId: json['open_id'],
        unionId: json['union_id'],
        avatarUrl: json['avatar_url'],
        avatarUrl100: json['avatar_url_100'],
        avatarLargeUrl: json['avatar_large_url'],
        displayName: json['display_name'],
        bioDescription: json['bio_description'],
        profileDeepLink: json['profile_deep_link'],
        isVerified: json['is_verified'],
        username: json['username'],
        followerCount: json['follower_count'],
        followingCount: json['following_count'],
        likesCount: json['likes_count'],
        videoCount: json['video_count']);
  }
}
