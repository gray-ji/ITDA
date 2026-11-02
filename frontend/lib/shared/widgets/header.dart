import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class Header extends StatelessWidget {
  final VoidCallback? onNotificationTap;

  const Header({
    super.key,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: SizedBox(
        height: 40,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 로고 + 앱 이름
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 40,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 8),
                const Text(
                  '잇다',
                  style: TextStyle(
                    fontFamily: 'Recipekorea',
                    fontSize: 24,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),

            // 알림 아이콘
            _NotificationButton(
              onTap: onNotificationTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationButton extends StatefulWidget {
  final VoidCallback? onTap;

  const _NotificationButton({
    this.onTap,
  });

  @override
  State<_NotificationButton> createState() =>
      _NotificationButtonState();
}

class _NotificationButtonState
    extends State<_NotificationButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: SizedBox(
        width: 44,
        height: 40,
        child: IconButton(
          onPressed: widget.onTap,
          padding: EdgeInsets.zero,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(
            _isHovered
                ? Icons.notifications_rounded
                : Icons.notifications_none_rounded,
            color: _isHovered
                ? AppColors.yellow
                : AppColors.gray1,
            size: 22,
          ),
        ),
      ),
    );
  }
}