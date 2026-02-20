import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpFeedbackPage extends StatefulWidget {
  const HelpFeedbackPage({super.key});

  @override
  State<HelpFeedbackPage> createState() => _HelpFeedbackPageState();
}

class _HelpFeedbackPageState extends State<HelpFeedbackPage> {
  final List<Map<String, String>> _faqs = [
    {
      'q': '如何获取更准确的穿搭建议？',
      'a': '您可以完善个人资料中的身份偏好，并在定制穿搭时提供详细的日期、地点、活动等信息，AI会根据这些条件为您生成更精准的方案。',
    },
    {'q': '系统怎么知道我所在地的天气？', 'a': '在首页，APP会自动获取您的地理位置并查询实时天气情况。请确保您已授予应用定位权限。'},
    {
      'q': '我如何添加我的真实衣服？',
      'a': '功能正在开发中：未来您将可以通过拍照上传自己的衣物，实现真正的虚拟试衣和基于您衣橱的个性化推荐，敬请期待！',
    },
    {'q': '如何更换主题颜色？', 'a': '在“我的”页面中，点击“切换深色/浅色主题”即可自由切换显示模式。'},
  ];

  Future<void> _launchEmail() async {
    const email = 'qingeneral@gmail.com';
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: _encodeQueryParameters(<String, String>{
        'subject': 'Cloova App Feedback',
      }),
    );

    try {
      if (!await launchUrl(emailLaunchUri)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('无法打开邮件应用，请直接发送邮件至 $email'),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('无法打开邮件应用，请直接发送邮件至 $email'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgPrimary,
      appBar: AppBar(
        title: Text(
          '帮助与反馈',
          style: TextStyle(
            color: context.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: context.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FAQ Section
            Text(
              '常见问题',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ..._faqs.map((faq) => _buildFaqItem(faq['q']!, faq['a']!)),

            const SizedBox(height: 32),

            // Feedback Section
            Text(
              '意见反馈',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '如果您遇到了问题，或者有任何建议，欢迎告诉我们：',
              style: TextStyle(fontSize: 14, color: context.textSecondary),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _launchEmail,
                icon: const Icon(Icons.email_outlined, color: Colors.white),
                label: const Text(
                  '发送邮件给开发者',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '或者直接发送至: qingeneral@gmail.com',
                style: TextStyle(color: context.textTertiary, fontSize: 13),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Cloova v1.0.0',
                style: TextStyle(
                  color: context.textTertiary.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: AppTheme.primaryBlue,
          collapsedIconColor: context.textTertiary,
          title: Text(
            question,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: context.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
