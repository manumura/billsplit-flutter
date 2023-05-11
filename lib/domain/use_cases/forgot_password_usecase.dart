import 'package:billsplit_flutter/data/auth/auth_provider.dart';
import 'package:billsplit_flutter/di/get_it.dart';

class ForgotPasswordUseCase {
  final _authProvider = getIt<AuthProvider>();

  Future launch(String email) async {
    await _authProvider.forgotPassword(email);
  }
}
