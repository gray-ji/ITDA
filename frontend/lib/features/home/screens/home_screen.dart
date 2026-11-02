import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/header.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../models/post.dart';
import '../widgets/search_bar.dart';
import '../widgets/post_card.dart';
import '../widgets/post_type_tabs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedNavIndex = 0;

  bool isFoundTab = true;

  final List<Post> posts = const [
    Post(
      postId: '1',
      title: '검정색 카드지갑을 주웠어요',
      category: Category.WALLET_MONEY_ID,
      status: Status.STORED,
      location: '서울시 마포구 홍대입구역',
      occurredFrom: '2026-11-01',
      createdAt: '2026-11-01T10:00:00',
    ),
    Post(
      postId: '2',
      title: '에어팟 케이스를 찾습니다',
      category: Category.ELECTRONICS,
      status: Status.LOOKING,
      location: '서울시 마포구 합정역',
      occurredFrom: '2026-10-31',
      createdAt: '2026-10-31T15:00:00',
    ),
    Post(
      postId: '3',
      title: '갈색 곰돌이 인형을 주웠어요',
      category: Category.STATIONERY_BOOKS,
      status: Status.STORED,
      location: '서울시 서대문구 연세대학교',
      occurredFrom: '2026-10-30',
      createdAt: '2026-11-01T10:00:00',
    ),
    Post(
      postId: '4',
      title: '회색 후드집업을 잃어버렸어요',
      category: Category.FASHION,
      status: Status.LOOKING,
      location: '서울시 마포구 상수역',
      occurredFrom: '2026-10-29',
      createdAt: '2026-10-31T15:00:00',
    ),
  ];

  // 화면 개발 단계에서 샘플 게시글을 구분하기 위한 임시 처리
  List<Post> get displayedPosts {
    return posts.where((post) {
      if (isFoundTab) {
        return post.status == Status.STORED;
      } else {
        return post.status == Status.LOOKING;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(
              onNotificationTap: () {
                // TODO: 알림 화면 연결
              },
            ),

            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      children: [
                        HomeSearchBar(
                          onTap: () {
                            // TODO: 검색 화면 연결
                          },
                        ),

                        const SizedBox(height: 24),

                        PostTypeTabs(
                          isFoundTab: isFoundTab,
                          onChanged: (isFound) {
                            setState(() {
                              isFoundTab = isFound;
                            });

                            // TODO:
                            // 선택한 탭에 맞는 게시글 API 호출
                            //
                            // isFound == true
                            // → 습득물 게시글 API
                            //
                            // isFound == false
                            // → 분실물 게시글 API
                          },
                        ),
                      ],
                    ),
                  ),

                  // 게시글 목록
                  Expanded(
                    child: displayedPosts.isEmpty
                        ? _buildEmptyState()
                        : ListView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            children: displayedPosts.map(
                              (post) {
                                return PostCard(
                                  post: post,
                                  onTap: () {
                                    // TODO: 게시글 상세 화면 연결
                                  },
                                );
                              },
                            ).toList(),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedNavIndex,
        onTap: (index) {
          setState(() {
            selectedNavIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: AppColors.gray3,
            size: 42,
          ),

          const SizedBox(height: 12),

          const Text(
            '게시글이 없어요',
            style: TextStyle(
              color: AppColors.gray1,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}