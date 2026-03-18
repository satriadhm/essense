enum CommunityFilter { forYou, trending, nearby, following }

extension CommunityFilterLabel on CommunityFilter {
  String get label {
    switch (this) {
      case CommunityFilter.forYou:
        return 'For You';
      case CommunityFilter.trending:
        return 'Trending';
      case CommunityFilter.nearby:
        return 'Nearby';
      case CommunityFilter.following:
        return 'Following';
    }
  }
}

class CommunityPost {
  final String id;
  final String authorName;
  final String authorHandle;
  final String location;
  final String timeAgo;
  final String caption;
  final List<String> tags;
  final String? imageAsset;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isSaved;
  final CommunityFilter filter;

  const CommunityPost({
    required this.id,
    required this.authorName,
    required this.authorHandle,
    required this.location,
    required this.timeAgo,
    required this.caption,
    required this.tags,
    required this.imageAsset,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    required this.isSaved,
    required this.filter,
  });

  CommunityPost copyWith({
    int? likeCount,
    int? commentCount,
    bool? isLiked,
    bool? isSaved,
  }) {
    return CommunityPost(
      id: id,
      authorName: authorName,
      authorHandle: authorHandle,
      location: location,
      timeAgo: timeAgo,
      caption: caption,
      tags: tags,
      imageAsset: imageAsset,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      filter: filter,
    );
  }
}

class CommunitySuggestion {
  final String id;
  final String name;
  final String handle;
  final String niche;
  final bool isFollowing;

  const CommunitySuggestion({
    required this.id,
    required this.name,
    required this.handle,
    required this.niche,
    required this.isFollowing,
  });

  CommunitySuggestion copyWith({bool? isFollowing}) {
    return CommunitySuggestion(
      id: id,
      name: name,
      handle: handle,
      niche: niche,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
