import 'package:flutter/material.dart';
import 'app_localizations.dart';

/// Shorthand extension for accessing AppLocalizations from any BuildContext.
/// Usage: `final l = context.l10n;` then `l.settings`, `l.cancel`, etc.
extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
