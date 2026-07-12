import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/haven_colors.dart';
import '../theme/haven_radius.dart';
import '../theme/haven_spacing.dart';
import '../theme/haven_typography.dart';
import 'haven_sheet.dart';
import 'haven_text_button.dart';

/// Custom date field — avoids Material date picker chrome (PD-037).
class HavenDateField extends StatelessWidget {
  const HavenDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  Future<void> _open(BuildContext context) async {
    var draft = value ?? DateTime.now().add(const Duration(days: 180));

    final picked = await HavenSheet.show<DateTime>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(label, style: HavenTypography.title),
                const SizedBox(height: HavenSpacing.md),
                CalendarDatePicker(
                  initialDate: draft,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                  onDateChanged: (d) => setLocal(() => draft = d),
                ),
                const SizedBox(height: HavenSpacing.sm),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(draft),
                  style: FilledButton.styleFrom(
                    backgroundColor: HavenColors.primary,
                    foregroundColor: HavenColors.surface,
                    padding: const EdgeInsets.symmetric(
                      vertical: HavenSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(HavenRadius.md),
                    ),
                  ),
                  child: const Text('Use this date'),
                ),
                HavenTextButton(
                  label: 'Clear',
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            );
          },
        );
      },
    );

    // null from Clear or dismiss — distinguish Clear by popping without value
    // from the Clear button which pops null; dismiss also null. Fine for MVP.
    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final display = value == null
        ? 'Optional'
        : DateFormat.yMMMd().format(value!);

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
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
        ),
        child: Text(display, style: HavenTypography.body),
      ),
    );
  }
}
