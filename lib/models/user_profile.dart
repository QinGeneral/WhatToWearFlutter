import 'package:what_to_wear_flutter/models/enums.dart';

// ═══════ User Preference ═══════
class UserPreference {
  final String id;
  final List<Style> style;
  final List<String> preferredColors;
  final List<String> dislikedColors;
  final Map<String, String> size;
  final List<Occasion> occasions;
  final Map<String, bool> notifications;
  final String theme;
  final String language;

  UserPreference({
    required this.id,
    required this.style,
    required this.preferredColors,
    required this.dislikedColors,
    required this.size,
    required this.occasions,
    required this.notifications,
    required this.theme,
    required this.language,
  });

  UserPreference copyWith({String? theme, String? language}) {
    return UserPreference(
      id: id,
      style: style,
      preferredColors: preferredColors,
      dislikedColors: dislikedColors,
      size: size,
      occasions: occasions,
      notifications: notifications,
      theme: theme ?? this.theme,
      language: language ?? this.language,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'style': style.map((s) => s.name).toList(),
    'preferredColors': preferredColors,
    'dislikedColors': dislikedColors,
    'size': size,
    'occasions': occasions.map((o) => o.name).toList(),
    'notifications': notifications,
    'theme': theme,
    'language': language,
  };

  factory UserPreference.fromJson(Map<String, dynamic> json) => UserPreference(
    id: json['id'] as String,
    style:
        (json['style'] as List?)
            ?.map(
              (s) => Style.values.firstWhere(
                (st) => st.name == s,
                orElse: () => Style.casual,
              ),
            )
            .toList() ??
        [Style.casual],
    preferredColors: List<String>.from(json['preferredColors'] ?? []),
    dislikedColors: List<String>.from(json['dislikedColors'] ?? []),
    size: Map<String, String>.from(json['size'] ?? {}),
    occasions:
        (json['occasions'] as List?)
            ?.map(
              (o) => Occasion.values.firstWhere(
                (oc) => oc.name == o,
                orElse: () => Occasion.casual,
              ),
            )
            .toList() ??
        [],
    notifications: Map<String, bool>.from(json['notifications'] ?? {}),
    theme: json['theme'] as String? ?? 'dark',
    language: json['language'] as String? ?? 'zh',
  );

  static UserPreference get defaultPreference => UserPreference(
    id: 'default',
    style: [Style.casual],
    preferredColors: [],
    dislikedColors: [],
    size: {'top': 'M', 'bottom': 'M', 'shoes': '42'},
    occasions: [],
    notifications: {'dailyRecommendation': false, 'weatherAlert': false},
    theme: 'dark',
    language: 'zh',
  );
}

// ═══════ User Profile ═══════
class UserProfile {
  final String id;
  final String? nickname;
  final String? avatar;
  final String createdAt;
  final UserIdentity? identity;
  final String? onboardingCompletedAt;

  UserProfile({
    required this.id,
    this.nickname,
    this.avatar,
    required this.createdAt,
    this.identity,
    this.onboardingCompletedAt,
  });

  UserProfile copyWith({
    String? nickname,
    UserIdentity? identity,
    String? onboardingCompletedAt,
  }) {
    return UserProfile(
      id: id,
      nickname: nickname ?? this.nickname,
      avatar: avatar,
      createdAt: createdAt,
      identity: identity ?? this.identity,
      onboardingCompletedAt:
          onboardingCompletedAt ?? this.onboardingCompletedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nickname': nickname,
    'avatar': avatar,
    'createdAt': createdAt,
    'identity': identity?.name,
    'onboardingCompletedAt': onboardingCompletedAt,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    nickname: json['nickname'] as String?,
    avatar: json['avatar'] as String?,
    createdAt: json['createdAt'] as String,
    identity: json['identity'] != null
        ? UserIdentity.values.firstWhere(
            // Support both new English key ('student') and legacy Chinese label ('校园学生')
            (i) => i.name == json['identity'] || i.displayName == json['identity'],
            orElse: () => UserIdentity.other,
          )
        : null,
    onboardingCompletedAt: json['onboardingCompletedAt'] as String?,
  );
}
