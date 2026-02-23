import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:what_to_wear_flutter/features/profile/view/onboarding_page.dart';
import 'package:what_to_wear_flutter/features/profile/view/profile_page.dart';
import 'package:what_to_wear_flutter/features/profile/view/help_feedback_page.dart';
import 'package:what_to_wear_flutter/features/profile/view/privacy_policy_page.dart';
import 'package:what_to_wear_flutter/features/developer/view/developer_page.dart';
import 'package:what_to_wear_flutter/features/recommendation/view/recommendation_page.dart';
import 'package:what_to_wear_flutter/features/recommendation/view/history_page.dart';
import 'package:what_to_wear_flutter/features/recommendation/view/favorite_outfits_page.dart';
import 'package:what_to_wear_flutter/features/recommendation/view/outfit_detail_page.dart';
import 'package:what_to_wear_flutter/features/wardrobe/view/wardrobe_page.dart';
import 'package:what_to_wear_flutter/features/wardrobe/view/add_item_page.dart';
import 'package:what_to_wear_flutter/models/models.dart';
import 'package:what_to_wear_flutter/core/router/app_routes.dart';
import 'package:what_to_wear_flutter/main.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter createRouter({required bool hasCompletedOnboarding}) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: hasCompletedOnboarding
          ? AppRoutes.home
          : AppRoutes.onboarding,
      routes: [
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingPage(),
        ),
        ShellRoute(
          navigatorKey: shellNavigatorKey,
          builder: (context, state, child) {
            return MainShell(child: child);
          },
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const RecommendationPage(),
              routes: [
                GoRoute(
                  path: 'outfit_detail', // Sub-routes use relative paths
                  builder: (context, state) {
                    final item = state.extra as Recommendation;
                    return OutfitDetailPage(recommendationId: item.id);
                  },
                ),
                GoRoute(
                  path: 'history',
                  builder: (context, state) => const HistoryPage(),
                ),
                GoRoute(
                  path: 'favorites',
                  builder: (context, state) => const FavoriteOutfitsPage(),
                ),
              ],
            ),
            GoRoute(
              path: AppRoutes.wardrobe,
              builder: (context, state) => const WardrobePage(),
              routes: [
                GoRoute(
                  path: 'add_item',
                  builder: (context, state) {
                    final itemId = state.extra as String?;
                    return AddItemPage(itemId: itemId);
                  },
                ),
              ],
            ),
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfilePage(),
              routes: [
                GoRoute(
                  path: 'help',
                  builder: (context, state) => const HelpFeedbackPage(),
                ),
                GoRoute(
                  path: 'privacy',
                  builder: (context, state) => const PrivacyPolicyPage(),
                ),
                GoRoute(
                  path: 'developer',
                  builder: (context, state) => const DeveloperPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
