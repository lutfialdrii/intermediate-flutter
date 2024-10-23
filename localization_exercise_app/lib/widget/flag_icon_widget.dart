import 'package:flutter/material.dart';
import 'package:localization_app/classes/localization.dart';
import 'package:localization_app/common/common.dart';
import 'package:localization_app/provider/localization_provider.dart';
import 'package:provider/provider.dart';

class FlagIconWidget extends StatelessWidget {
  const FlagIconWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton(
      icon: const Icon(Icons.flag),
      items: AppLocalizations.supportedLocales.map(
        (Locale locale) {
          final flag = Localization.getFlag(locale.languageCode);
          return DropdownMenuItem(
            value: locale,
            child: Center(
              child: Text(flag),
            ),
            onTap: () {
              Provider.of<LocalizationProvider>(context, listen: false)
                  .setLocale(locale);
            },
          );
        },
      ).toList(),
      onChanged: (value) {},
    ));
  }
}
