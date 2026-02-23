import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class AnalyticsService {
  /// Initialize the UMeng analytics service
  static void init() {
    // Set to manual page collection mode so we can use onPageStart/onPageEnd
    UmengCommonSdk.setPageCollectionModeManual();
  }

  /// Send a custom event with optional properties
  static void onEvent(String eventId, [Map<String, dynamic>? properties]) {
    if (properties != null) {
      UmengCommonSdk.onEvent(eventId, properties);
    } else {
      // The SDK might require properties, but if it has an overload,
      // we can just pass an empty map or call without properties if supported.
      // Based on the provided example, passing properties is standard.
      UmengCommonSdk.onEvent(eventId, {});
    }
  }

  /// Log in a user profile
  static void onProfileSignIn(String userId) {
    UmengCommonSdk.onProfileSignIn(userId);
  }

  /// Log out a user profile
  static void onProfileSignOff() {
    UmengCommonSdk.onProfileSignOff();
  }

  /// Mark the start of a page view
  static void onPageStart(String viewName) {
    UmengCommonSdk.onPageStart(viewName);
  }

  /// Mark the end of a page view
  static void onPageEnd(String viewName) {
    UmengCommonSdk.onPageEnd(viewName);
  }
}
