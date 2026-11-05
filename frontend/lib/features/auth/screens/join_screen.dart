import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

import 'join_complete_screen.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final _controller = TextEditingController();
  bool _agreed = false;

  bool get _canSubmit => _controller.text.trim().isNotEmpty && _agreed;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 약관 내용 모달 (화면 정가운데 팝업)
  void _showTerms() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420, maxHeight: 520),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '서비스 이용약관',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: AppColors.gray1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Flexible(
                    child: SingleChildScrollView(
                      child: Text(
                        // TODO: 실제 약관 내용으로 교체
                        '제1조 (목적)\n'
                        '이 약관은 잇다 서비스의 이용과 관련하여 서비스와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.\n\n'
                        '제2조 (서비스 내용)\n'
                        '잇다는 분실물과 습득물 정보를 등록하고, 관련 게시글을 추천하며, 이용자 간 소통과 반환 기록 관리를 지원합니다.\n\n'
                        '제3조 (개인정보 수집 및 이용)\n'
                        '서비스는 카카오 로그인 시 제공되는 식별자와 이용자가 설정한 닉네임을 서비스 제공 목적으로 수집하고 이용합니다.\n\n'
                        '제4조 (이용자의 의무)\n'
                        '이용자는 타인의 정보를 도용하거나 허위 게시글을 등록해서는 안 됩니다.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _agreed = true);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        foregroundColor: AppColors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '동의하고 닫기',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                '사용할 닉네임을\n입력해주세요',
                style: TextStyle(
                  fontSize: 24,
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '다른 사용자에게 보여지는 이름이에요',
                style: TextStyle(fontSize: 14, color: AppColors.gray1),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _controller,
                maxLength: 30,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: '닉네임',
                  hintStyle: const TextStyle(color: AppColors.gray2),
                  filled: true,
                  fillColor: AppColors.gray6,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.yellow),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 약관 동의 (체크박스 + 약관 보기)
              Row(
                children: [
                  Checkbox(
                    value: _agreed,
                    onChanged: (value) =>
                        setState(() => _agreed = value ?? false),
                    activeColor: AppColors.yellow,
                    checkColor: AppColors.black,
                    side: const BorderSide(color: AppColors.gray3, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: _showTerms,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              '[필수] 약관 동의',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.black,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.chevron_right,
                                color: AppColors.gray1, size: 22),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _canSubmit
                      ? () {
                          // TODO: 가입 완료 API 호출 후 이동
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const JoinCompleteScreen()),
                        );
                          debugPrint('닉네임: ${_controller.text.trim()}');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.black,
                    disabledBackgroundColor: AppColors.gray5,
                    disabledForegroundColor: AppColors.gray2,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '가입 완료',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}