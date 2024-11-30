import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../bloc/user/user_bloc.dart';

class VerifyPasswordCode extends StatefulWidget {
  const VerifyPasswordCode({super.key, required this.changeIndex});
  final void Function(int) changeIndex;

  @override
  State<VerifyPasswordCode> createState() => _VerifyPasswordCodeState();
}

class _VerifyPasswordCodeState extends State<VerifyPasswordCode> {
  final TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state.verifyPasswordCodeStatus ==
            VerifyPasswordCodeStatus.success) {
          widget.changeIndex(5);
        } else if (state.verifyPasswordCodeStatus ==
            VerifyPasswordCodeStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text(
                  state.errorMessage ??
                      AppLocalizations.of(context)!
                          .verifyPasswordCodeErrorOccurred,
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
            AppLocalizations.of(context)!.verifyPasswordCodeTitle,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.verifyPasswordCodePrompt,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(width: 8),
              Text(
                context.watch<UserBloc>().state.email ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          OtpTextField(
            numberOfFields: 4,
            filled: true,
            fieldWidth: 50,
            margin: const EdgeInsets.only(right: 12),
            enabledBorderColor: Theme.of(context).colorScheme.primaryContainer,
            fillColor: Theme.of(context).colorScheme.primaryContainer,
            focusedBorderColor: Theme.of(context).colorScheme.primary,
            showFieldAsBox: true,
            onCodeChanged: (String code) {
              codeController.text += code;
            },
            onSubmit: (String verificationCode) {
              context.read<UserBloc>().add(VerifyPasswordCodeEvent(
                  email: context.read<UserBloc>().state.email ?? '',
                  code: verificationCode));

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(
                      child: Text(AppLocalizations.of(context)!
                          .verifyPasswordCodeVerifyingMessage)),
                  duration: Duration(seconds: 1),
                ),
              );
              if (context.read<UserBloc>().state.verifyEmailStatus ==
                  VerifyEmailStatus.success) {
                widget.changeIndex(0);
              }
            },
          ),
          const SizedBox(height: 40),
          context.watch<UserBloc>().state.verifyPasswordCodeStatus ==
                  VerifyPasswordCodeStatus.loading
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
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(
                          child: Text(
                            AppLocalizations.of(context)!
                                .verifyPasswordCodeInvalidCodeMessage,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onError,
                            ),
                          ),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  },
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
                      AppLocalizations.of(context)!.verifyPasswordCodeButton,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!
                    .verifyPasswordCodeDidNotReceiveOtp,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  context.read<UserBloc>().add(ResetPasswordRequestEvent(
                      email: context.read<UserBloc>().state.email ?? ''));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                          child: Text(AppLocalizations.of(context)!
                              .verifyPasswordCodeSentToEmail)),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.verifyPasswordCodeResendCode,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}