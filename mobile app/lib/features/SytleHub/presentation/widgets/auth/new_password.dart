import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../bloc/user/user_bloc.dart';
import '../common/CustomInputField.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key, required this.changeIndex});

  final void Function(int) changeIndex;

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  String? passwordError;
  String? confirmPasswordError;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void validatePassword(String value) {
    setState(() {
      passwordError = value.isEmpty
          ? AppLocalizations.of(context)!.newPasswordCannotBeEmpty
          : null;
    });
  }

  void validateConfirmPassword(String value) {
    setState(() {
      confirmPasswordError = value.isEmpty
          ? AppLocalizations.of(context)!.newPasswordConfirmCannotBeEmpty
          : null;
      if (value != passwordController.text) {
        confirmPasswordError =
            AppLocalizations.of(context)!.newPasswordMismatch;
      }
    });
  }

  void onClearPasswordError() {
    setState(() {
      passwordError = null;
    });
  }

  void onClearConfirmPasswordError() {
    setState(() {
      confirmPasswordError = null;
    });
  }

  void onResetPassword() {
    if (passwordError == null && confirmPasswordError == null) {
      context.read<UserBloc>().add(
            ResetPasswordEvent(
              password: passwordController.text.trim(),
            ),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              AppLocalizations.of(context)!.newPasswordEnterValidPassword,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state.resetPasswordStatus == ResetPasswordStatus.success) {
          widget.changeIndex(0);
        } else if (state.resetPasswordStatus == ResetPasswordStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text(
                  state.errorMessage ??
                      AppLocalizations.of(context)!
                          .newPasswordSomethingWentWrong,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onError,
                  ),
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.newPasswordTitle,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          Text(
            AppLocalizations.of(context)!.newPasswordPrompt,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 40),
          CustomInputField(
            controller: passwordController,
            hintText: AppLocalizations.of(context)!.newPasswordHint,
            obscureText: !_passwordVisible,
            prefixIcon: Icons.lock,
            suffixIcon:
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
            onChanged: validatePassword,
            errorText: passwordError,
            suffixIconOnPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
          const SizedBox(height: 16),
          CustomInputField(
            controller: confirmPasswordController,
            hintText: AppLocalizations.of(context)!.newPasswordConfirmHint,
            obscureText: !_confirmPasswordVisible,
            prefixIcon: Icons.lock,
            suffixIcon: _confirmPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off,
            onChanged: validateConfirmPassword,
            errorText: confirmPasswordError,
            suffixIconOnPressed: () {
              setState(() {
                _confirmPasswordVisible = !_confirmPasswordVisible;
              });
            },
          ),
          const SizedBox(height: 40),
          context.watch<UserBloc>().state.resetPasswordStatus ==
                  ResetPasswordStatus.loading
              ? Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                )
              : ElevatedButton(
                  onPressed: onResetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    maximumSize: const Size(360, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.newPasswordResetButton,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
