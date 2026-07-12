import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/haven_colors.dart';
import '../theme/haven_radius.dart';
import '../theme/haven_spacing.dart';
import '../theme/haven_typography.dart';

/// Haven text field — gentle focus, large touch target (PD-037).
class HavenTextField extends StatelessWidget {
  const HavenTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onChanged,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      style: HavenTypography.body,
      cursorColor: HavenColors.primary,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: HavenTypography.bodySmall.copyWith(
          color: HavenColors.textSecondary,
        ),
        filled: true,
        fillColor: HavenColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: HavenSpacing.md,
          vertical: HavenSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HavenRadius.input),
          borderSide: const BorderSide(color: HavenColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HavenRadius.input),
          borderSide: const BorderSide(color: HavenColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HavenRadius.input),
          borderSide: const BorderSide(color: HavenColors.primary, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HavenRadius.input),
          borderSide: const BorderSide(color: HavenColors.borderSubtle),
        ),
      ),
    );
  }
}

/// Currency-aware amount field.
class HavenAmountField extends StatelessWidget {
  const HavenAmountField({
    super.key,
    required this.controller,
    required this.label,
    this.currency = 'EGP',
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String currency;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return HavenTextField(
      controller: controller,
      label: '$label ($currency)',
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: onChanged,
    );
  }
}
