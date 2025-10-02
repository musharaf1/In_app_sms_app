import 'package:flutter/material.dart';
import 'package:inapp_sms/core/theme/app_pallet.dart';

class AppTheme {
  static _border([Color color = AppPallet.borderColor]) => OutlineInputBorder(
    borderSide: BorderSide(color: color),
    borderRadius: BorderRadius.circular(10),
  );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallet.universalBlack,

    inputDecorationTheme: InputDecorationThemeData(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: _border(),
      border: _border(),
      focusedBorder: _border(AppPallet.formError),

      errorBorder: _border(AppPallet.formError),
    ),

    appBarTheme: AppBarTheme(backgroundColor: AppPallet.universalBlack),

    chipTheme: ChipThemeData(
      color: WidgetStatePropertyAll(AppPallet.universalBlack),
      side: BorderSide.none,
    ),
  );
}
