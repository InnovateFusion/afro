import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../bloc/user/user_bloc.dart';
import '../common/CustomInputField.dart';

class ResetYourPassword extends StatefulWidget {
  const ResetYourPassword({super.key, required this.changeIndex});

  final void Function(int) changeIndex;

  @override
  State<ResetYourPassword> createState() => _ResetYourPasswordState();
}

class _ResetYourPasswordState extends State<ResetYourPassword> {
  final TextEditingController emailController = TextEditingController();
  String? emailError;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void validateEmail(String value) {
    setState(() {
      emailError = value.isEmpty
          ? AppLocalizations.of(context)!.resetPasswordEmailCannotBeEmpty
          : null;
    });
  }

  void onClearEmailError() {
    setState(() {
      emailError = null;
    });
  }

  void onResetPasswordRequest() {
    if (emailError == null) {
      context.read<UserBloc>().add(
            ResetPasswordRequestEvent(email: emailController.text.trim()),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              AppLocalizations.of(context)!.resetPasswordEnterValidEmail,
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
        if (state.resetPasswordRequestStatus ==
            ResetPasswordRequestStatus.success) {
          widget.changeIndex(4);
        } else if (state.resetPasswordRequestStatus ==
            ResetPasswordRequestStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text(
                  state.errorMessage ??
                      AppLocalizations.of(context)!
                          .resetPasswordSomethingWentWrong,
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
            AppLocalizations.of(context)!.resetPasswordTitle,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          Text(
            AppLocalizations.of(context)!.resetPasswordPrompt,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 40),
          CustomInputField(
            controller: emailController,
            prefixIcon: Icons.email,
            hintText: AppLocalizations.of(context)!.resetPasswordEmailHint,
            onChanged: validateEmail,
            errorText: emailError,
          ),
          const SizedBox(height: 40),
          context.watch<UserBloc>().state.resetPasswordRequestStatus ==
                  ResetPasswordRequestStatus.loading
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
                  onPressed: onResetPasswordRequest,
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
                      AppLocalizations.of(context)!.resetPasswordSendButton,
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
