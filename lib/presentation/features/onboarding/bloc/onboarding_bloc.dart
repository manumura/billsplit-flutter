import 'dart:io';

import 'package:billsplit_flutter/domain/models/currency.dart';
import 'package:billsplit_flutter/domain/models/phone_number.dart';
import 'package:billsplit_flutter/domain/use_cases/currency_usecases/get_exchange_rates_usecase.dart';
import 'package:billsplit_flutter/domain/use_cases/profile/parse_phonenumber_usecase.dart';
import 'package:billsplit_flutter/domain/use_cases/profile/update_display_name_usecase.dart';
import 'package:billsplit_flutter/presentation/base/bloc/base_cubit.dart';
import 'package:billsplit_flutter/presentation/base/bloc/base_state.dart';
import 'package:billsplit_flutter/presentation/features/onboarding/bloc/onboarding_state.dart';

class OnboardingBloc extends BaseCubit {
  final _updateNameUseCase = UpdateDisplayNameUseCase();
  final _getCurrencies = GetExchangeRatesUseCase();
  final _parsePhoneNumberUseCase = ParsePhoneNumberUseCase();

  String _name = "";
  Currency currency = Currency.USD();
  File? displayPhoto;
  PhoneNumber? phoneNumber;

  OnboardingBloc() {
    _name = user.nameState;
    _initCurrency();
    _initPhoneNumber();
  }

  _initPhoneNumber() {
    _parsePhoneNumberUseCase.launch(user.phoneNumberState.dial).then((value) {
      phoneNumber = value;
    });
  }

  _initCurrency() {
    _getCurrencies.launch().then((_) {
      final currencyRate =
          sharedPrefs.latestExchangeRates[sharedPrefs.userPrefDefaultCurrency];
      if (currencyRate != null) {
        currency = Currency(
          symbol: sharedPrefs.userPrefDefaultCurrency,
          rate: currencyRate,
        );
      }
    }).catchError((err, stackTrace) {
      showError(err, stackTrace);
    });
  }

  Future updateName(String name) async {
    await _updateNameUseCase.launch(name);
    user.nameState = name;
  }

  void submitProfile() {
    showLoading();
    _updateNameUseCase.launch(name).then((value) {
      emit(SubmitUserSuccessEvent());
    }).catchError((err, stackTrace) {
      showError(err, stackTrace);
    });
  }

  void updateCurrency(Currency currency) {
    sharedPrefs.userPrefDefaultCurrency = currency.symbol;
    emit(Main());
  }

  void onNextClicked() {
    emit(NextStepEvent());
  }

  void onPreviousClicked() {
    emit(PreviousStepEvent());
  }

  void onNameChanged(String value) {
    _name = value;
    emit(Main());
  }

  String get name {
    return _name;
  }

  String get greeting {
    if (_name.isEmpty) return "Hi you!";
    return "Hi $_name!";
  }
}
