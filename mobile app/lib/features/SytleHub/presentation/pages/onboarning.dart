import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../setUp/language/localize.dart';
import '../../../../setUp/size/app_size.dart';
import '../bloc/language/language_bloc.dart';
import '../bloc/user/user_bloc.dart';
import 'auth.dart';
import 'layout.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = [
      {
        "title": AppLocalizations.of(context)!.onboardingTitle1,
        "description": AppLocalizations.of(context)!.onboardingDescription1,
        "image": "assets/images/onboarding/1.png",
      },
      {
        "title": AppLocalizations.of(context)!.onboardingTitle2,
        "description": AppLocalizations.of(context)!.onboardingDescription2,
        "image": "assets/images/onboarding/2.png",
      },
      {
        "title": AppLocalizations.of(context)!.onboardingTitle3,
        "description": AppLocalizations.of(context)!.onboardingDescription3,
        "image": "assets/images/onboarding/3.png",
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state.loginStatus == LoginStatus.success ||
                state.loginWithTiktokStatus == LoginWithTiktokStatus.success) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Layout(),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.smallSize),
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
                  Expanded(
                    child: PageView.builder(
                      itemCount: data.length,
                      onPageChanged:
                          _onPageChanged, // Added onPageChanged callback
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(data[currentIndex]["image"]!,
                                width: 300, height: 300),
                            Text(
                              data[currentIndex]["title"]!,
                              style: const TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 340,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  data[currentIndex]["description"]!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(data.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    _onPageChanged(index);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: currentIndex == index
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Auth()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                maximumSize: const Size(340, 60),
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
                                  AppLocalizations.of(context)!.getStarted,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
