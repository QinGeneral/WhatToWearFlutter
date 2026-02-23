import 'package:flutter/material.dart';
import 'package:what_to_wear_flutter/services/analytics_service.dart';

class AnalyticsRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (previousRoute is PageRoute && previousRoute.settings.name != null) {
      AnalyticsService.onPageEnd(previousRoute.settings.name!);
    }
    if (route is PageRoute && route.settings.name != null) {
      AnalyticsService.onPageStart(route.settings.name!);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route is PageRoute && route.settings.name != null) {
      AnalyticsService.onPageEnd(route.settings.name!);
    }
    if (previousRoute is PageRoute && previousRoute.settings.name != null) {
      AnalyticsService.onPageStart(previousRoute.settings.name!);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute is PageRoute && oldRoute.settings.name != null) {
      AnalyticsService.onPageEnd(oldRoute.settings.name!);
    }
    if (newRoute is PageRoute && newRoute.settings.name != null) {
      AnalyticsService.onPageStart(newRoute.settings.name!);
    }
  }
}
