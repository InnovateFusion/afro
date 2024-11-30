import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

import '../../../../setUp/size/app_size.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/CustomInputField.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? oldPasswordError;
  String? newPasswordError;
  String? confirmPasswordError;

  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  void validateOldPassword(String value) {
    if (value.isEmpty) {
      setState(() {
        oldPasswordError = AppLocalizations.of(context)!
            .passwordResetScreen_oldPasswordRequired;
      });
    } else if (oldPasswordController.text.length < 6) {
      setState(() {
        oldPasswordError =
            AppLocalizations.of(context)!.passwordResetScreen_passwordMinLength;
      });
    } else {
      setState(() {
        oldPasswordError = null;
      });
    }
  }

  void validateNewPassword(String value) {
    if (value.isEmpty) {
      setState(() {
        newPasswordError = AppLocalizations.of(context)!
            .passwordResetScreen_newPasswordRequired;
      });
    } else if (newPasswordController.text.length < 6) {
      setState(() {
        newPasswordError =
            AppLocalizations.of(context)!.passwordResetScreen_passwordMinLength;
      });
    } else {
      setState(() {
        newPasswordError = null;
      });
    }
  }

  void validateConfirmPassword(String value) {
    if (value.isEmpty) {
      setState(() {
        confirmPasswordError = AppLocalizations.of(context)!
            .passwordResetScreen_newPasswordRequired;
      });
    } else if (newPasswordController.text != confirmPasswordController.text) {
      setState(() {
        confirmPasswordError =
            AppLocalizations.of(context)!.passwordResetScreen_passwordMismatch;
      });
    } else {
      setState(() {
        confirmPasswordError = null;
      });
    }
  }

  Widget builderDetails(String title, Widget value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: AppSize.xSmallSize),
        value,
      ],
    );
  }

  void onSubmit() {
    if (oldPasswordError == null &&
        newPasswordError == null &&
        confirmPasswordError == null) {
      context.read<ProductBloc>().add(ResetMyPasswordEvent(
            token: context.read<UserBloc>().state.user?.token ?? '',
            oldPassword: oldPasswordController.text,
            newPassword: newPasswordController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: SingleChildScrollView(
          child: BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state.myPasswordResetStatus ==
                  MyPasswordResetStatus.success) {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(
                      child: Text(
                        AppLocalizations.of(context)!
                            .passwordResetScreen_passwordResetSuccess,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                );
              } else if (state.myPasswordResetStatus ==
                  MyPasswordResetStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(
                      child: Text(
                        state.errorMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                );
              }
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSize.smallSize),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_outlined,
                          size: 32,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .passwordResetScreen_resetPassword,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(width: 32),
                    ],
                  ),
                ),
                Divider(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSize.smallSize),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      builderDetails(
                        AppLocalizations.of(context)!
                            .passwordResetScreen_oldPassword,
                        CustomInputField(
                          controller: oldPasswordController,
                          hintText: AppLocalizations.of(context)!
                              .passwordResetScreen_oldPassword,
                          errorText: oldPasswordError,
                          onChanged: validateOldPassword,
                          obscureText: !_oldPasswordVisible,
                          prefixIcon: Icons.lock,
                          suffixIcon: _oldPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          suffixIconOnPressed: () {
                            setState(() {
                              _oldPasswordVisible = !_oldPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: AppSize.largeSize),
                      builderDetails(
                        AppLocalizations.of(context)!
                            .passwordResetScreen_newPassword,
                        CustomInputField(
                          controller: newPasswordController,
                          hintText: AppLocalizations.of(context)!
                              .passwordResetScreen_newPassword,
                          errorText: newPasswordError,
                          onChanged: validateNewPassword,
                          obscureText: !_newPasswordVisible,
                          prefixIcon: Icons.lock,
                          suffixIcon: _newPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          suffixIconOnPressed: () {
                            setState(() {
                              _newPasswordVisible = !_newPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: AppSize.largeSize),
                      builderDetails(
                        AppLocalizations.of(context)!
                            .passwordResetScreen_confirmPassword,
                        CustomInputField(
                          controller: confirmPasswordController,
                          hintText: AppLocalizations.of(context)!
                              .passwordResetScreen_confirmPassword,
                          errorText: confirmPasswordError,
                          onChanged: validateConfirmPassword,
                          obscureText: !_confirmPasswordVisible,
                          prefixIcon: Icons.lock,
                          suffixIcon: _confirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          suffixIconOnPressed: () {
                            setState(() {
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: AppSize.largeSize),
                      if (context
                              .watch<ProductBloc>()
                              .state
                              .myPasswordResetStatus ==
                          MyPasswordResetStatus.loading)
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius:
                                BorderRadius.circular(AppSize.xSmallSize),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: onSubmit,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.smallSize,
                                vertical: AppSize.smallSize),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius:
                                  BorderRadius.circular(AppSize.xSmallSize),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .passwordResetScreen_updatePassword,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
