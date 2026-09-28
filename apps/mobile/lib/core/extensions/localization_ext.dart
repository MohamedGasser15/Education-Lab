import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/core/models/currency_info.dart';
import 'package:mobile/core/services/currency_service.dart';

extension LocalizationExt on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';

  CurrencyInfo get currency => watch<CurrencyService>().currentCurrency;

  String formatPrice(double usdAmount, {bool showApproxUsd = false}) =>
      watch<CurrencyService>().formatPrice(
        usdAmount,
        isArabic: isArabic,
        showApproxUsd: showApproxUsd,
      );

  String formatPriceRead(double usdAmount, {bool showApproxUsd = false}) =>
      read<CurrencyService>().formatPrice(
        usdAmount,
        isArabic: isArabic,
        showApproxUsd: showApproxUsd,
      );
}
