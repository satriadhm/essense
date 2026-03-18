import 'dart:math';

import 'package:flutter/material.dart';

import '../models/community_models.dart';
import '../theme/app_theme.dart';
import '../widgets/community/community_composer_card.dart';
import '../widgets/community/community_empty_state.dart';
import '../widgets/community/community_error_state.dart';
import '../widgets/community/community_filter_chips.dart';
import '../widgets/community/community_loading_skeleton.dart';
import '../widgets/community/community_post_card.dart';
import '../widgets/community/suggested_users_carousel.dart';
import '../widgets/bottom_nav/custom_bottom_nav.dart';

enum _CommunityViewState { loading, content, empty, error }

class CommunityScreen extends StatefulWidget {
  final bool showBottomNav;

  const CommunityScreen({super.key, this.showBottomNav = true});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final ScrollController _scrollController = ScrollController();
  final Random _random = Random();

  CommunityFilter _activeFilter = CommunityFilter.forYou;
  _CommunityViewState _viewState = _CommunityViewState.loading;
  bool _isLoadingMore = false;
  int _currentNavIndex = 2;
  int _loadRound = 0;

  late final List<CommunityPost> _seedPosts;
  List<CommunityPost> _posts = const [];
  List<CommunitySuggestion> _suggestions = const [];

  @override
  void initState() {
    super.initState();
    _seedPosts = _buildSeedPosts();
    _suggestions = _buildSuggestions();
    _scrollController.addListener(_onScroll);
    _bootstrap();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    setState(() => _viewState = _CommunityViewState.loading);
    await Future<void>.delayed(const Duration(milliseconds: 550));
    _applyFilter(resetFeed: true);
  }

  void _onScroll() {
    if (_viewState != _CommunityViewState.content || _isLoadingMore) return;
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 200) return;

    _loadMore();
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final more = _buildMorePosts();
    setState(() {
      _posts = [..._posts, ...more];
      _isLoadingMore = false;
    });
  }

  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    _applyFilter(resetFeed: true);
  }

  void _applyFilter({required bool resetFeed}) {
    final filtered = _seedPosts
        .where((post) {
          if (_activeFilter == CommunityFilter.forYou) return true;
          return post.filter == _activeFilter;
        })
        .toList();

    setState(() {
      _posts = resetFeed ? filtered : [..._posts, ...filtered];
      _viewState = _posts.isEmpty
          ? _CommunityViewState.empty
          : _CommunityViewState.content;
    });
  }

  List<CommunityPost> _buildMorePosts() {
    _loadRound += 1;
    return _seedPosts
        .where((post) {
          if (_activeFilter == CommunityFilter.forYou) return true;
          return post.filter == _activeFilter;
        })
        .take(2)
        .map(
          (post) => CommunityPost(
            id: '${post.id}_$_loadRound',
            authorName: post.authorName,
            authorHandle: post.authorHandle,
            location: post.location,
            timeAgo: '${_random.nextInt(30) + 1}m',
            caption: post.caption,
            tags: post.tags,
            imageAsset: post.imageAsset,
            likeCount: post.likeCount + _random.nextInt(9),
            commentCount: post.commentCount + _random.nextInt(4),
            isLiked: false,
            isSaved: false,
            filter: post.filter,
          ),
        )
        .toList();
  }

  void _toggleLike(String postId) {
    setState(() {
      _posts = _posts
          .map((post) {
            if (post.id != postId) return post;
            final nextLiked = !post.isLiked;
            return post.copyWith(
              isLiked: nextLiked,
              likeCount: nextLiked ? post.likeCount + 1 : post.likeCount - 1,
            );
          })
          .toList();
    });
  }

  void _toggleSave(String postId) {
    setState(() {
      _posts = _posts
          .map(
            (post) => post.id == postId
                ? post.copyWith(isSaved: !post.isSaved)
                : post,
          )
          .toList();
    });
  }

  void _toggleFollow(String userId) {
    setState(() {
      _suggestions = _suggestions
          .map(
            (user) => user.id == userId
                ? user.copyWith(isFollowing: !user.isFollowing)
                : user,
          )
          .toList();
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  List<CommunityPost> _buildSeedPosts() {
    return const [
      CommunityPost(
        id: 'post_1',
        authorName: 'Mia Laurent',
        authorHandle: '@mial',
        location: 'Paris',
        timeAgo: '12m',
        caption:
            'Layered Mon Paris with a vanilla mist today. Lasted through a long client day and still felt soft by sunset.',
        tags: ['#MonParis', '#OfficeDay', '#LongLasting'],
        imageAsset: 'assets/images/mon_paris.png',
        likeCount: 124,
        commentCount: 19,
        isLiked: false,
        isSaved: false,
        filter: CommunityFilter.trending,
      ),
      CommunityPost(
        id: 'post_2',
        authorName: 'Aria Noor',
        authorHandle: '@aria',
        location: 'Jakarta',
        timeAgo: '37m',
        caption:
            'Humid weather today, but this citrus opening stayed crisp. Sharing this for anyone testing fresh daytime profiles.',
        tags: ['#Fresh', '#HumidWeather', '#DaytimeScent'],
        imageAsset: 'assets/images/activity_card_1.png',
        likeCount: 89,
        commentCount: 11,
        isLiked: true,
        isSaved: false,
        filter: CommunityFilter.trending,
      ),
      CommunityPost(
        id: 'post_3',
        authorName: 'Nora Belle',
        authorHandle: '@nora',
        location: 'Milan',
        timeAgo: '1h',
        caption:
            'My evening dinner pick: floral heart with dry amber base. Smooth projection without overwhelming the room.',
        tags: ['#DinnerDate', '#FloralAmber', '#SOTD'],
        imageAsset: 'assets/images/activity_card_2.png',
        likeCount: 233,
        commentCount: 42,
        isLiked: false,
        isSaved: true,
        filter: CommunityFilter.following,
      ),
      CommunityPost(
        id: 'post_4',
        authorName: 'Jasmine Rose',
        authorHandle: '@jasmine',
        location: 'Singapore',
        timeAgo: '2h',
        caption:
            'Tested a minimalist routine this morning and got cleaner transitions between top and mid notes.',
        tags: ['#Routine', '#MinimalLayering', '#Essense'],
        imageAsset: null,
        likeCount: 54,
        commentCount: 8,
        isLiked: false,
        isSaved: false,
        filter: CommunityFilter.trending,
      ),
    ];
  }

  List<CommunitySuggestion> _buildSuggestions() {
    return const [
      CommunitySuggestion(
        id: 's1',
        name: 'Lina Petit',
        handle: '@linap',
        niche: 'Clean Florals',
        isFollowing: false,
      ),
      CommunitySuggestion(
        id: 's2',
        name: 'Kaito Jun',
        handle: '@kaitoj',
        niche: 'Woody Notes',
        isFollowing: true,
      ),
      CommunitySuggestion(
        id: 's3',
        name: 'Esha Noor',
        handle: '@eshan',
        niche: 'Evening Layers',
        isFollowing: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.accentCyan,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.headerTop + 8,
                  AppSpacing.screenHorizontal,
                  0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Community', style: AppTextStyles.bannerTitle),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _showMessage('Search is frontend-only for now'),
                          icon: const Icon(
                            Icons.search_rounded,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(
                            () => _viewState = _CommunityViewState.error,
                          ),
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  8,
                  AppSpacing.screenHorizontal,
                  0,
                ),
                child: CommunityFilterChips(
                  activeFilter: _activeFilter,
                  onFilterSelected: (filter) {
                    setState(() => _activeFilter = filter);
                    _applyFilter(resetFeed: true);
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  14,
                  AppSpacing.screenHorizontal,
                  0,
                ),
                child: CommunityComposerCard(
                  onPostTap: () => _showMessage('Post composer is frontend-only'),
                  onPhotoTap: () => _showMessage('Photo upload is frontend-only'),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  18,
                  AppSpacing.screenHorizontal,
                  8,
                ),
                child: Text(
                  'SUGGESTED CREATORS',
                  style: AppTextStyles.sectionTitle.copyWith(letterSpacing: 0.8),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                ),
                child: SuggestedUsersCarousel(
                  suggestions: _suggestions,
                  onFollowToggle: _toggleFollow,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  18,
                  AppSpacing.screenHorizontal,
                  8,
                ),
                child: Text(
                  'COMMUNITY FEED',
                  style: AppTextStyles.sectionTitle.copyWith(letterSpacing: 0.8),
                ),
              ),
            ),
            ..._buildFeedSlivers(),
            SliverToBoxAdapter(
              child: SizedBox(
                height: AppSpacing.navBarHeight + AppSpacing.navBarBottom + 14,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.showBottomNav
          ? CustomBottomNav(
              currentIndex: _currentNavIndex,
              onTap: (i) => setState(() => _currentNavIndex = i),
            )
          : null,
    );
  }

  List<Widget> _buildFeedSlivers() {
    switch (_viewState) {
      case _CommunityViewState.loading:
        return const [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 720,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                child: CommunityLoadingSkeleton(),
              ),
            ),
          ),
        ];
      case _CommunityViewState.error:
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: CommunityErrorState(
              onRetryTap: () {
                _showMessage('Retrying...');
                _bootstrap();
              },
            ),
          ),
        ];
      case _CommunityViewState.empty:
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: CommunityEmptyState(
              onExploreTap: () {
                setState(() => _activeFilter = CommunityFilter.forYou);
                _applyFilter(resetFeed: true);
              },
            ),
          ),
        ];
      case _CommunityViewState.content:
        return [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final itemCount = _posts.length + (_isLoadingMore ? 1 : 0);
                if (index >= itemCount) return null;

                if (index >= _posts.length) {
                  return Container(
                    height: 56,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.accentCyan,
                    ),
                  );
                }

                final post = _posts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CommunityPostCard(
                    post: post,
                    onLikeTap: () => _toggleLike(post.id),
                    onCommentTap: () =>
                        _showMessage('Comments are frontend-only for now'),
                    onSaveTap: () => _toggleSave(post.id),
                    onShareTap: () =>
                        _showMessage('Share sheet is frontend-only for now'),
                  ),
                );
              }),
            ),
          ),
        ];
    }
  }
}
