import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../setUp/size/app_size.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/app_bar_one.dart';

class ShopReviewWrite extends StatefulWidget {
  const ShopReviewWrite({super.key, required this.shopId});
  final String shopId;

  @override
  State<ShopReviewWrite> createState() => _ShopReviewWriteState();
}

class _ShopReviewWriteState extends State<ShopReviewWrite> {
  double selectedRating = 0;
  TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget builderDetails(String title, Widget value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSize.xSmallSize),
          value,
        ],
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: BlocListener<ShopBloc, ShopState>(
          listener: (context, state) {
            if (state.addReviewStatus == AddReviewStatus.success ||
                state.addReviewStatus == AddReviewStatus.loaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(
                    child: Text(
                      AppLocalizations.of(context)!.shopReviewWrite_success,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              );
              Navigator.pop(context);
            }
            if (state.addReviewStatus == AddReviewStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(
                    child: Text(
                      state.errorMessage,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              );
            }
          },
          child: Stack(
            children: [
              Column(
                children: [
                  const AppBarOne(),
                  Divider(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    thickness: 2,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.smallSize),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            builderDetails(
                              AppLocalizations.of(context)!
                                  .shopReviewWrite_yourReview,
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius:
                                      BorderRadius.circular(AppSize.smallSize),
                                ),
                                padding:
                                    const EdgeInsets.all(AppSize.smallSize),
                                child: TextField(
                                  maxLines: 5,
                                  controller: reviewController,
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!
                                        .shopReviewWrite_reviewHint,
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSize.mediumSize),
                            builderDetails(
                              AppLocalizations.of(context)!
                                  .shopReviewWrite_rating,
                              RatingStars(
                                axis: Axis.horizontal,
                                value: selectedRating,
                                starCount: 5,
                                starSize: 40,
                                onValueChanged: (value) {
                                  setState(() {
                                    selectedRating = value;
                                  });
                                },
                                valueLabelColor: const Color(0xff9b9b9b),
                                valueLabelTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12.0),
                                valueLabelRadius: 10,
                                maxValue: 5,
                                starSpacing: 8,
                                maxValueVisibility: true,
                                valueLabelVisibility: false,
                                animationDuration:
                                    const Duration(milliseconds: 1000),
                                valueLabelPadding: const EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 8),
                                valueLabelMargin:
                                    const EdgeInsets.only(right: 8),
                                starOffColor: const Color(0xffe7e8ea),
                                starColor: Colors.yellow,
                                angle: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (context.read<ShopBloc>().state.addReviewStatus !=
                          AddReviewStatus.loading) {
                        context.read<ShopBloc>().add(
                              AddReviewEvent(
                                shopId: widget.shopId,
                                review: reviewController.text,
                                rating: selectedRating.toInt(),
                                token: context
                                        .read<UserBloc>()
                                        .state
                                        .user!
                                        .token ??
                                    '',
                              ),
                            );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      margin: const EdgeInsets.all(AppSize.smallSize),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius:
                            BorderRadius.circular(AppSize.xxSmallSize),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .shopReviewWrite_addReview,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (context.watch<ShopBloc>().state.addReviewStatus ==
                  AddReviewStatus.loading)
                Container(
                  color: Theme.of(context).colorScheme.scrim.withOpacity(0.95),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: SpinKitCircle(
                        size: 200,
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(300),
                              color: index.isEven
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                            ),
                          );
                        },
                      )),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
