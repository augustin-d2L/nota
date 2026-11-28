import 'package:flutter/material.dart';
import 'package:nota/l10n/generated/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(body: Center(child: Text(l10n.homeEmptyMessage)));
  }
}
