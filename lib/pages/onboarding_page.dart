import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/profile_provider.dart';
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';

class OnboardingPage extends StatefulWidget {
  final bool fromProfile;

  const OnboardingPage({super.key, this.fromProfile = false});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  String _currentStep = 'name';
  String _name = '';
  UserIdentity? _selectedIdentity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgPrimary,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _currentStep == 'name'
              ? _buildNameStep()
              : _buildIdentityStep(),
        ),
      ),
    );
  }

  Widget _buildNameStep() {
    return Padding(
      key: const ValueKey('name'),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          Text('👋', style: TextStyle(fontSize: 48)),
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
            '让我来了解你的风格',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: context.textSecondary),
          ),
          const SizedBox(height: 48),
          Text(
            '你的昵称',
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
              hintText: '输入你的名字',
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
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _name.trim().isNotEmpty
                    ? () => setState(() => _currentStep = 'identity')
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  disabledBackgroundColor: context.cardAlt,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  '继续',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _name.trim().isNotEmpty
                        ? Colors.white
                        : context.textTertiary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityStep() {
    return Padding(
      key: const ValueKey('identity'),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() => _currentStep = 'name'),
                icon: Icon(Icons.arrow_back, color: context.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '你的身份是？',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '帮我更好地了解你的穿衣风格',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.textSecondary),
          ),
          const SizedBox(height: 32),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedIdentity != null
                    ? () => _completeOnboarding()
                    : null,
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
                      widget.fromProfile ? '保存修改' : '开启推荐之旅',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: _selectedIdentity != null
                            ? Colors.white
                            : context.textTertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_selectedIdentity != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        widget.fromProfile ? Icons.check : Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _completeOnboarding() {
    final provider = context.read<ProfileProvider>();
    if (widget.fromProfile) {
      provider.updateIdentity(_selectedIdentity!);
      Navigator.of(context).pop();
    } else {
      provider.completeOnboarding(_name.trim(), _selectedIdentity!);
    }
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
                  child: const Icon(Icons.check, color: Colors.white, size: 14),
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
                    identity.name,
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
