import '../../../../core/utils/enum.dart';
import '../bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../setUp/size/app_size.dart';
import '../../../shared/presentation/pages/layout.dart';
import 'CustomInputField.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key, required this.changeIndex});

  final void Function(int) changeIndex;

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
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void validateEmail(String value) {
    setState(() {
      emailError = value.isEmpty ? "Email cannot be empty" : null;
    });
  }

  void validatePassword(String value) {
    setState(() {
      passwordError = value.isEmpty ? "Password cannot be empty" : null;
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
        emailError = "Email cannot be empty";
      });
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = "Password cannot be empty";
      });
    }

    if (emailError == null && passwordError == null) {
      context.read<AuthBloc>().add(SignInEvent(
            email: emailController.text,
            password: passwordController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.signInStatus == ApiRequestStatus.success) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Layout(),
            ),
          );
        } else if (state.signInStatus == ApiRequestStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(
                child: Text(
                    state.error ?? "An error occurred, please try again",
                    textAlign: TextAlign.center)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/Afro.png",
            width: 80,
            height: 80,
          ),
          Text(
            "Sign In",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          Text(
            "Login in to your account\nLet's get started",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 40),
          CustomInputField(
            controller: emailController,
            hintText: "Email",
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
                hintText: "Password",
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
            ],
          ),
          const SizedBox(height: 40),
          context.watch<AuthBloc>().state.signInStatus ==
                  ApiRequestStatus.loading
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
                  onPressed: onSignIn,
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
                      "Sign In",
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
          const SizedBox(height: AppSize.mediumSize),
        ],
      ),
    );
  }
}
