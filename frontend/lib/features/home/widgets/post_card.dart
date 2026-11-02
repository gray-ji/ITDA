import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
  });

  Color get statusColor {
    switch (post.status) {
      case Status.looking:
        return AppColors.yellow;
      case Status.stored:
        return AppColors.blue;
      case Status.returned:
        return AppColors.gray1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.gray5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      // 상태 칩
                      _buildChip(
                        label: post.statusLabel,
                        backgroundColor: statusColor,
                        textColor: statusColor,
                      ),

                      // 카테고리 칩
                      _buildChip(
                        label: post.categoryLabel,
                        backgroundColor: AppColors.gray2,
                        textColor: AppColors.gray2,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 제목
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 장소
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.gray1,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          post.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.gray1,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // 발생일
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: AppColors.gray2,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatOccurredDate(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.gray2,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (post.thumbnailUrl != null &&
        post.thumbnailUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          post.thumbnailUrl!,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _imagePlaceholder();
          },
        ),
      );
    }

    return _imagePlaceholder();
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.gray6,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.image_outlined,
        color: AppColors.gray3,
        size: 30,
      ),
    );
  }

  // 발생일 또는 추정 기간 표시
  String _formatOccurredDate() {
    final from = _formatDate(post.occurredFrom);

    if (post.occurredTo == null ||
        post.occurredTo!.isEmpty ||
        post.occurredFrom == post.occurredTo) {
      return from;
    }

    final to = _formatDate(post.occurredTo!);

    return '$from ~ $to';
  }

  // ISO 날짜를 yyyy.MM.dd 형태로 표시
  String _formatDate(String date) {
    final parsed = DateTime.tryParse(date);

    if (parsed == null) {
      return date;
    }

    return '${parsed.year}.'
        '${parsed.month.toString().padLeft(2, '0')}.'
        '${parsed.day.toString().padLeft(2, '0')}';
  }
}