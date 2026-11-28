import 'package:flutter/material.dart';
import 'package:nota/l10n/generated/app_localizations.dart';
import 'package:nota/ui/home/widgets/home_screen.dart';

class NotaApp extends StatelessWidget {
  const NotaApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: ThemeData(

        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(),
    );
  }
}