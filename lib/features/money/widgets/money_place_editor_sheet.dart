import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../../../widgets/haven_primary_button.dart';
import '../../../widgets/haven_text_button.dart';
import '../cubit/money_cubit.dart';
import '../models/money_place.dart';

/// Bottom sheet for adding or editing a Money Place (PD-035).
class MoneyPlaceEditorSheet extends StatefulWidget {
  const MoneyPlaceEditorSheet({
    super.key,
    this.place,
  });

  final MoneyPlace? place;

  static Future<void> show(BuildContext context, {MoneyPlace? place}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: HavenColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => MoneyPlaceEditorSheet(place: place),
    );
  }

  @override
  State<MoneyPlaceEditorSheet> createState() => _MoneyPlaceEditorSheetState();
}

class _MoneyPlaceEditorSheetState extends State<MoneyPlaceEditorSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;

  bool get _isEditing => widget.place != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.place?.name ?? '');
    _balanceController = TextEditingController(
      text: widget.place?.balance.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    final balance = int.tryParse(_balanceController.text.trim());
    if (name.isEmpty || balance == null) return;

    final cubit = context.read<MoneyCubit>();
    if (_isEditing) {
      cubit.editPlace(
        id: widget.place!.id,
        name: name,
        balance: balance,
      );
    } else {
      cubit.addPlace(name: name, balance: balance);
    }
    Navigator.of(context).pop();
  }

  void _delete() {
    if (!_isEditing) return;
    context.read<MoneyCubit>().deletePlace(widget.place!.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        HavenSpacing.lg,
        HavenSpacing.lg,
        HavenSpacing.lg,
        HavenSpacing.lg + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _isEditing ? 'Edit place' : 'Add place',
            style: HavenTypography.title,
          ),
          const SizedBox(height: HavenSpacing.lg),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: HavenSpacing.md),
          TextField(
            controller: _balanceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Balance (EGP)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: HavenSpacing.sm),
          Text(
            'Source: Manual',
            style: HavenTypography.caption.copyWith(
              color: HavenColors.textTertiary,
            ),
          ),
          const SizedBox(height: HavenSpacing.lg),
          HavenPrimaryButton(label: 'Save', onPressed: _save),
          if (_isEditing) ...[
            const SizedBox(height: HavenSpacing.sm),
            HavenTextButton(label: 'Delete', onPressed: _delete),
          ],
        ],
      ),
    );
  }
}
