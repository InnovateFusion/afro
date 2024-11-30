import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../setUp/language/localize.dart';
import '../../../../setUp/size/app_size.dart';
import '../bloc/language/language_bloc.dart';
import '../widgets/auth/new_password.dart';
import '../widgets/auth/reset_your_password.dart';
import '../widgets/auth/signin.dart';
import '../widgets/auth/signup.dart';
import '../widgets/auth/verify_code.dart';
import '../widgets/auth/verify_password_code.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  int currentIndex = 0;

  void onChangeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  late final List<Widget> _children = [
    SignIn(changeIndex: onChangeIndex),
    SignUp(changeIndex: onChangeIndex),
    VerifyCode(changeIndex: onChangeIndex),
    ResetYourPassword(changeIndex: onChangeIndex),
    VerifyPasswordCode(changeIndex: onChangeIndex),
    NewPassword(changeIndex: onChangeIndex),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSize.smallSize),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButton<Locale>(
                      value: context.watch<LanguageBloc>().state.locale,
                      onChanged: (Locale? newLocale) {
                        if (newLocale != null) {
                          context
                              .read<LanguageBloc>()
                              .add(ChangeLanguageEvent(locale: newLocale));
                        }
                      },
                      items: L10n.all.map((locale) {
                        final flag = L10n.getFlag(locale.languageCode);
                        return DropdownMenuItem(
                          value: locale,
                          child: Text(flag),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 360,
                    ),
                    child: _children[currentIndex],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
