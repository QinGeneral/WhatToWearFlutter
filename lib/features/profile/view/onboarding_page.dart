import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:what_to_wear_flutter/core/router/app_routes.dart';
import 'package:what_to_wear_flutter/features/profile/provider/profile_provider.dart';
import 'package:what_to_wear_flutter/l10n/app_localizations.dart';
import 'package:what_to_wear_flutter/models/models.dart';
import 'package:what_to_wear_flutter/theme/app_colors.dart';
import 'package:what_to_wear_flutter/theme/app_theme.dart';

// ─── Step definition ────────────────────────────────────────────────────────

enum _Step { name, identity, features, permissions, addClothing }

// ─── Page ───────────────────────────────────────────────────────────────────

class OnboardingPage extends StatefulWidget {
  final bool fromProfile;

  const OnboardingPage({super.key, this.fromProfile = false});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  _Step _step = _Step.name;
  String _name = '';
  UserIdentity? _selectedIdentity;

  // Feature tour
  final PageController _featurePageController = PageController();
  int _featurePage = 0;

  // Permission states
  bool _locationGranted = false;

  @override
  void dispose() {
    _featurePageController.dispose();
    super.dispose();
  }

  // Total steps for progress indicator (only in fresh onboarding)
  int get _totalSteps => widget.fromProfile ? 2 : 5;

  int get _currentStepIndex {
    if (widget.fromProfile) {
      return _step == _Step.name ? 0 : 1;
    }
    return _step.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            if (!widget.fromProfile) _buildProgressBar(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) => SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  child: child,
                ),
                child: _buildCurrentStep(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: List.generate(_totalSteps, (i) {
          final filled = i <= _currentStepIndex;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < _totalSteps - 1 ? 6 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: filled
                    ? AppColors.primaryBlue
                    : AppColors.primaryBlue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_step) {
      case _Step.name:
        return _buildNameStep();
      case _Step.identity:
        return _buildIdentityStep();
      case _Step.features:
        return _buildFeaturesStep();
      case _Step.permissions:
        return _buildPermissionsStep();
      case _Step.addClothing:
        return _buildAddClothingStep();
    }
  }

  // ─── Step 1: Name ──────────────────────────────────────────────────────────

  Widget _buildNameStep() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      key: const ValueKey(_Step.name),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          const Text('👋', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'Welcome!',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingWelcomeTagline,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: context.textSecondary,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            l10n.onboardingYourNickname,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.textTertiary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (v) => setState(() => _name = v),
            style: context.textTheme.titleLarge?.copyWith(
              color: context.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: l10n.onboardingNameHint,
              hintStyle: TextStyle(
                color: context.textTertiary.withValues(alpha: 0.5),
              ),
              filled: true,
              fillColor: context.cardAlt,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
          ),
          const Spacer(),
          _PrimaryButton(
            label: l10n.continueAction,
            enabled: _name.trim().isNotEmpty,
            onTap: () => setState(() => _step = _Step.identity),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ─── Step 2: Identity ──────────────────────────────────────────────────────

  Widget _buildIdentityStep() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      key: const ValueKey(_Step.identity),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _BackButton(onTap: () => setState(() => _step = _Step.name)),
          const SizedBox(height: 16),
          Text(
            l10n.onboardingWhoAreYou,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingIdentitySubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.95,
              children: UserIdentity.values.map((identity) {
                final selected = _selectedIdentity == identity;
                return _IdentityCard(
                  identity: identity,
                  selected: selected,
                  onTap: () => setState(() => _selectedIdentity = identity),
                );
              }).toList(),
            ),
          ),
          _PrimaryButton(
            label: widget.fromProfile ? l10n.saveChanges : l10n.continueAction,
            enabled: _selectedIdentity != null,
            onTap: () {
              if (widget.fromProfile) {
                _completeFromProfile();
              } else {
                setState(() => _step = _Step.features);
              }
            },
            trailing: widget.fromProfile ? Icons.check : Icons.arrow_forward,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ─── Step 3: Feature Tour ──────────────────────────────────────────────────

  List<({IconData icon, Color color, String title, String description})> _buildFeatures(AppLocalizations l10n) => [
    (
      icon: Icons.wb_sunny_outlined,
      color: const Color(0xFFF59E0B),
      title: l10n.featureAITitle,
      description: l10n.featureAIDesc,
    ),
    (
      icon: Icons.checkroom_outlined,
      color: const Color(0xFF6366F1),
      title: l10n.featureWardrobeTitle,
      description: l10n.featureWardrobeDesc,
    ),
    (
      icon: Icons.auto_awesome_outlined,
      color: const Color(0xFF10B981),
      title: l10n.featureTryOnTitle,
      description: l10n.featureTryOnDesc,
    ),
  ];

  Widget _buildFeaturesStep() {
    final l10n = AppLocalizations.of(context)!;
    final features = _buildFeatures(l10n);
    return Padding(
      key: const ValueKey(_Step.features),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 48),
          Text(
            l10n.onboardingCapabilities,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingSwipeToLearnMore,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.textTertiary,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: PageView.builder(
              controller: _featurePageController,
              itemCount: features.length,
              onPageChanged: (i) => setState(() => _featurePage = i),
              itemBuilder: (context, i) {
                final f = features[i];
                return _FeatureCard(
                  icon: f.icon,
                  color: f.color,
                  title: f.title,
                  description: f.description,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(features.length, (i) {
              final active = i == _featurePage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.primaryBlue
                      : AppColors.primaryBlue.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
          const SizedBox(height: 32),
          _PrimaryButton(
            label: l10n.onboardingNext,
            enabled: true,
            onTap: () => setState(() => _step = _Step.permissions),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ─── Step 4: Permissions ───────────────────────────────────────────────────

  Widget _buildPermissionsStep() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      key: const ValueKey(_Step.permissions),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48),
          Text(
            l10n.onboardingEnablePermissions,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingPermissionsSubtitle,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          _PermissionCard(
            icon: Icons.location_on_outlined,
            color: AppColors.primaryBlue,
            title: l10n.permissionLocation,
            description: l10n.permissionLocationDesc,
            granted: _locationGranted,
            onRequest: _requestLocationPermission,
          ),
          const SizedBox(height: 16),
          _PermissionCard(
            icon: Icons.photo_library_outlined,
            color: const Color(0xFF6366F1),
            title: l10n.permissionPhoto,
            description: l10n.permissionPhotoDesc,
            granted: false,
            isAutoGranted: true,
            onRequest: null, // 上传时系统自动请求
          ),
          const Spacer(),
          _PrimaryButton(
            label: l10n.continueAction,
            enabled: true,
            onTap: () => setState(() => _step = _Step.addClothing),
          ),
          TextButton(
            onPressed: () => setState(() => _step = _Step.addClothing),
            child: Center(
              child: Text(
                l10n.permissionSkip,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.textTertiary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    if (mounted) {
      setState(() {
        _locationGranted = permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse;
      });
    }
  }

  // ─── Step 5: Add First Clothing ────────────────────────────────────────────

  Widget _buildAddClothingStep() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      key: const ValueKey(_Step.addClothing),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add_a_photo_outlined,
              size: 52,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            l10n.onboardingAddFirstItem,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.onboardingAddFirstItemDesc,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.textSecondary,
              height: 1.6,
            ),
          ),
          const Spacer(),
          _PrimaryButton(
            label: l10n.onboardingAddNow,
            enabled: true,
            onTap: _completeAndAddClothing,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _completeOnboarding,
            child: Center(
              child: Text(
                l10n.onboardingAddLater,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.textTertiary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ─── Actions ───────────────────────────────────────────────────────────────

  Future<void> _completeOnboarding() async {
    final provider = context.read<ProfileProvider>();
    await provider.completeOnboarding(_name.trim(), _selectedIdentity!);
    // GoRouter reacts to hasCompletedOnboarding → redirects to home
  }

  Future<void> _completeAndAddClothing() async {
    await _completeOnboarding();
    if (mounted) {
      context.go(AppRoutes.addItem);
    }
  }

  void _completeFromProfile() {
    final provider = context.read<ProfileProvider>();
    provider.updateIdentity(_selectedIdentity!);
    Navigator.of(context).pop();
  }
}

// ─── Shared Widgets ─────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(Icons.arrow_back, color: context.textPrimary),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  final IconData? trailing;

  const _PrimaryButton({
    required this.label,
    required this.enabled,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          disabledBackgroundColor: context.cardAlt,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: enabled ? Colors.white : context.textTertiary,
              ),
            ),
            if (trailing != null && enabled) ...[
              const SizedBox(width: 8),
              Icon(trailing, color: Colors.white, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: context.borderColor, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 44, color: color),
          ),
          const SizedBox(height: 28),
          Text(
            title,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final bool granted;
  final bool isAutoGranted;
  final VoidCallback? onRequest;

  const _PermissionCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.granted,
    this.isAutoGranted = false,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    final isGranted = granted || isAutoGranted;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isGranted ? color.withValues(alpha: 0.4) : context.borderColor,
          width: isGranted ? 1.5 : 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isAutoGranted ? '$description（${AppLocalizations.of(context)!.permissionAutoGranted}）' : description,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (isGranted)
            Icon(Icons.check_circle, color: color, size: 24)
          else if (!isAutoGranted)
            TextButton(
              onPressed: onRequest,
              style: TextButton.styleFrom(
                foregroundColor: color,
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: Text(AppLocalizations.of(context)!.permissionGrant, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}

class _IdentityCard extends StatelessWidget {
  final UserIdentity identity;
  final bool selected;
  final VoidCallback onTap;

  const _IdentityCard({
    required this.identity,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? AppColors.primaryBlue : Colors.transparent,
            width: 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.2),
                    blurRadius: 15,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            if (selected)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: identity.color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(identity.icon, color: identity.color, size: 28),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    identity.displayName,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    identity.description,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
