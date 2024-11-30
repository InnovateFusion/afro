import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../setUp/service/local_cache.dart';
import '../../../../../setUp/size/app_size.dart';
import '../../bloc/user/user_bloc.dart';
import '../../pages/layout.dart';
import '../common/CustomInputField.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key, required this.changeIndex});

  final void Function(int) changeIndex;

  static const platform = MethodChannel("com.example.afro_stores/auth");

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _passwordVisible = false;

  String? emailError;
  String? passwordError;

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(ClearStateEvent());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void validateEmail(String value) {
    setState(() {
      emailError = value.isEmpty
          ? AppLocalizations.of(context)!.signInEmailCannotBeEmpty
          : null;
    });
  }

  void validatePassword(String value) {
    setState(() {
      passwordError = value.isEmpty
          ? AppLocalizations.of(context)!.signInPasswordCannotBeEmpty
          : null;
    });
  }

  void clearErrors() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  void onSignIn() {
    clearErrors();

    if (emailController.text.isEmpty) {
      setState(() {
        emailError = AppLocalizations.of(context)!.signInEmailCannotBeEmpty;
      });
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError =
            AppLocalizations.of(context)!.signInPasswordCannotBeEmpty;
      });
    }

    if (emailError == null && passwordError == null) {
      context.read<UserBloc>().add(
            SignInEvent(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            ),
          );
    }
  }

  void onTikTokSignIn() async {
    try {
      await LocalCache.saveString("currentChannel", "authorizeTikTok");
      await SignIn.platform.invokeMethod('authorizeTikTok');
    } on PlatformException {
      () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(
              child: Text(
                  AppLocalizations.of(context)!.signInSomethingWentWrong,
                  textAlign: TextAlign.center)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state.loginStatus == LoginStatus.success ||
            state.loginWithTiktokStatus == LoginWithTiktokStatus.success) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Layout(),
            ),
          );

          clearFields();
        } else if (state.loginStatus == LoginStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(
                child: Text(
                    state.errorMessage ??
                        AppLocalizations.of(context)!.signInSomethingWentWrong,
                    textAlign: TextAlign.center)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));

          if (state.errorMessage?.trim() ==
              AppLocalizations.of(context)!.signInEmailNotVerified) {
            widget.changeIndex(2);
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.signInTitle,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          Text(
            AppLocalizations.of(context)!.signInPrompt,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 40),
          CustomInputField(
            controller: emailController,
            hintText: AppLocalizations.of(context)!.signInEmailHint,
            prefixIcon: Icons.email,
            onChanged: validateEmail,
            errorText: emailError,
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomInputField(
                controller: passwordController,
                hintText: AppLocalizations.of(context)!.signInPasswordHint,
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
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  widget.changeIndex(3);
                },
                child: Text(
                  AppLocalizations.of(context)!.signInForgotPassword,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          context.watch<UserBloc>().state.loginStatus == LoginStatus.loading
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
                    if (context.read<UserBloc>().state.loginWithTiktokStatus !=
                        LoginWithTiktokStatus.loading) {
                      onSignIn();
                    }
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
                      vertical: 14,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.signInTitle,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
          const SizedBox(height: AppSize.mediumSize),
          (context.watch<UserBloc>().state.loginWithTiktokStatus ==
                  LoginWithTiktokStatus.loading)
              ? Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
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
                    if (context.read<UserBloc>().state.loginStatus !=
                        LoginStatus.loading) {
                      onTikTokSignIn();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    elevation: 0,
                    maximumSize: const Size(360, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/tiktok.svg',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Continue with TikTok",
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.signInNoAccountPrompt,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  widget.changeIndex(1);
                },
                child: Text(
                  AppLocalizations.of(context)!.signInSignUp,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
