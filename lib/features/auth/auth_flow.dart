import 'package:flutter/material.dart';

import '../../theme/haven_colors.dart';
import '../../theme/haven_spacing.dart';
import '../../theme/haven_typography.dart';
import '../../widgets/haven_logo.dart';
import '../../widgets/haven_primary_button.dart';
import '../../widgets/haven_text_button.dart';

/// Placeholder authentication — validates navigation, not identity.
class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

enum _AuthStep { welcome, createAccount, signIn }

class _AuthFlowState extends State<AuthFlow> {
  _AuthStep _step = _AuthStep.welcome;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HavenColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(HavenSpacing.lg),
          child: switch (_step) {
            _AuthStep.welcome => _Welcome(
                onCreate: () => setState(() => _step = _AuthStep.createAccount),
                onSignIn: () => setState(() => _step = _AuthStep.signIn),
              ),
            _AuthStep.createAccount => _AccountForm(
                title: 'Create your Haven',
                subtitle: 'A calm place to understand your money.',
                nameController: _nameController,
                emailController: _emailController,
                primaryLabel: 'Continue',
                onPrimary: widget.onContinue,
                onBack: () => setState(() => _step = _AuthStep.welcome),
              ),
            _AuthStep.signIn => _AccountForm(
                title: 'Welcome back',
                subtitle: 'Continue where you left off.',
                nameController: _nameController,
                emailController: _emailController,
                primaryLabel: 'Sign in',
                onPrimary: widget.onContinue,
                onBack: () => setState(() => _step = _AuthStep.welcome),
                showName: false,
              ),
          },
        ),
      ),
    );
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({required this.onCreate, required this.onSignIn});

  final VoidCallback onCreate;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        const Center(child: HavenLogo(height: 64)),
        const SizedBox(height: HavenSpacing.lg),
        Text(
          'Haven',
          textAlign: TextAlign.center,
          style: HavenTypography.h1,
        ),
        const SizedBox(height: HavenSpacing.sm),
        Text(
          'Navigate your money with confidence.',
          textAlign: TextAlign.center,
          style: HavenTypography.body.copyWith(
            color: HavenColors.textSecondary,
          ),
        ),
        const Spacer(),
        HavenPrimaryButton(label: 'Create account', onPressed: onCreate),
        const SizedBox(height: HavenSpacing.sm),
        HavenTextButton(label: 'Sign in', onPressed: onSignIn),
        const SizedBox(height: HavenSpacing.lg),
      ],
    );
  }
}

class _AccountForm extends StatelessWidget {
  const _AccountForm({
    required this.title,
    required this.subtitle,
    required this.nameController,
    required this.emailController,
    required this.primaryLabel,
    required this.onPrimary,
    required this.onBack,
    this.showName = true,
  });

  final String title;
  final String subtitle;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback onBack;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        ),
        const SizedBox(height: HavenSpacing.md),
        Text(title, style: HavenTypography.h1),
        const SizedBox(height: HavenSpacing.sm),
        Text(
          subtitle,
          style: HavenTypography.body.copyWith(
            color: HavenColors.textSecondary,
          ),
        ),
        const SizedBox(height: HavenSpacing.xl),
        if (showName) ...[
          TextField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Your name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: HavenSpacing.md),
        ],
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const Spacer(),
        HavenPrimaryButton(label: primaryLabel, onPressed: onPrimary),
        const SizedBox(height: HavenSpacing.md),
        Text(
          'Placeholder auth — no password, no backend.',
          textAlign: TextAlign.center,
          style: HavenTypography.caption,
        ),
      ],
    );
  }
}
