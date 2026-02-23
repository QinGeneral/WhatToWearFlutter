import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:what_to_wear_flutter/l10n/app_localizations.dart';
import '../pages/privacy_policy_page.dart';

// 在用户点击“同意”按钮时调用：
Future<void> agreePrivacyPolicy() async {
  try {
    await UmengCommonSdk.initCommon(
      '699b155d6f259537c7605e61',
      '699b155d6f259537c7605e61',
      'Umeng',
    );
    debugPrint("友盟 SDK 已正式初始化");
  } catch (e) {
    debugPrint("初始化友盟失败: $e");
  }
}

Future<bool> checkAndShowPrivacyDialog(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final agreed = prefs.getBool('agreed_privacy') ?? false;
  if (agreed) return true;

  final l10n = AppLocalizations.of(context)!;

  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return PopScope(
        canPop: false, // 禁止返回键关闭
        child: AlertDialog(
          title: Text(l10n.privacyDialogTitle),
          content: SingleChildScrollView(
            child: RichText(
              text: TextSpan(
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.5),
                children: [
                  TextSpan(text: l10n.privacyDialogContentPart1),
                  TextSpan(
                    text: '《${l10n.privacyPolicy}》',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            settings: const RouteSettings(
                              name: '/PrivacyPolicyPage',
                            ),
                            builder: (context) => const PrivacyPolicyPage(),
                          ),
                        );
                      },
                  ),

                  TextSpan(text: l10n.privacyDialogContentPart3),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(
                l10n.decline,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await prefs.setBool('agreed_privacy', true);
                agreePrivacyPolicy(); // Don't await to avoid UI blocking
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop(true);
                }
              },
              child: Text(
                l10n.agreeAndContinue,
                style: TextStyle(
                  color: Theme.of(dialogContext).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );

  return result ?? false;
}
