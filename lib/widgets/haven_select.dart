import 'package:flutter/material.dart';

import '../theme/haven_colors.dart';
import '../theme/haven_radius.dart';
import '../theme/haven_spacing.dart';
import '../theme/haven_typography.dart';
import 'haven_sheet.dart';

class HavenSelectOption<T> {
  const HavenSelectOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// Bottom-sheet select — replaces Material dropdowns (PD-037).
class HavenSelect<T> extends StatelessWidget {
  const HavenSelect({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    this.placeholder = 'Choose',
    this.allowNone = true,
  });

  final String label;
  final List<HavenSelectOption<T>> options;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String placeholder;
  final bool allowNone;

  String get _display {
    if (value == null) return placeholder;
    for (final option in options) {
      if (option.value == value) return option.label;
    }
    return placeholder;
  }

  Future<void> _open(BuildContext context) async {
    final result = await HavenSheet.show<_SelectResult<T>>(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label, style: HavenTypography.title),
            const SizedBox(height: HavenSpacing.md),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  if (allowNone)
                    ListTile(
                      title: Text('None', style: HavenTypography.body),
                      onTap: () => Navigator.of(ctx).pop(
                        _SelectResult<T>.cleared(),
                      ),
                    ),
                  for (final option in options)
                    ListTile(
                      title: Text(option.label, style: HavenTypography.body),
                      trailing: option.value == value
                          ? const Icon(Icons.check_rounded,
                              color: HavenColors.primary)
                          : null,
                      onTap: () => Navigator.of(ctx).pop(
                        _SelectResult<T>.selected(option.value),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
    if (result == null) return;
    onChanged(result.value);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _open(context),
      borderRadius: BorderRadius.circular(HavenRadius.input),
      child: InputDecorator(
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
          suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
        child: Text(_display, style: HavenTypography.body),
      ),
    );
  }
}

class _SelectResult<T> {
  const _SelectResult.selected(this.value);
  const _SelectResult.cleared() : value = null;

  final T? value;
}
