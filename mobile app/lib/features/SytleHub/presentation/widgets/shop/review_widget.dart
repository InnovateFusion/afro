import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../core/utils/captilizations.dart';
import '../../../../../setUp/size/app_size.dart';
import '../../../domain/entities/shop/review_entity.dart';

class ReviewWidget extends StatefulWidget {
  final ReviewEntity review;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final bool isShowEditAndDelete;

  const ReviewWidget({
    super.key,
    required this.review,
    this.onDelete,
    this.onEdit,
    this.isShowEditAndDelete = false,
  });

  @override
  _ReviewWidgetState createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final review = widget.review;
    final text = Captilizations.capitalize(review.review);
    final isTextLong = text.length > 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 45,
              height: 45,
              padding: EdgeInsets.all(review.image != null ? 0 : 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundImage: review.image != null
                    ? NetworkImage(review.image!) as ImageProvider
                    : const AssetImage(
                        "assets/images/Screens/person.png",
                      ),
              ),
            ),
            const SizedBox(width: AppSize.smallSize),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${Captilizations.capitalize(review.firstName)} ${Captilizations.capitalize(review.lastName)}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                Row(
                  children: [
                    RatingStars(
                      axis: Axis.horizontal,
                      value: review.rating.toDouble(),
                      starCount: 5,
                      starSize: 20,
                      valueLabelColor: const Color(0xff9b9b9b),
                      valueLabelTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 12.0),
                      valueLabelRadius: 10,
                      maxValue: 5,
                      starSpacing: 2,
                      maxValueVisibility: true,
                      valueLabelVisibility: false,
                      animationDuration: const Duration(milliseconds: 1000),
                      valueLabelPadding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 8),
                      valueLabelMargin: const EdgeInsets.only(right: 8),
                      starOffColor: const Color(0xffe7e8ea),
                      starColor: Colors.yellow,
                      angle: 12,
                    ),
                    const SizedBox(width: AppSize.xSmallSize),
                    Text(
                      timeago.format(review.createdAt),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ],
                ),
              ],
            ),
            if (widget.isShowEditAndDelete) const Spacer(),
            if (widget.isShowEditAndDelete)
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'edit') {
                    widget.onEdit?.call();
                  } else if (value == 'delete') {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(AppSize.xSmallSize),
                            ),
                          ),
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete,
                                  color: Theme.of(context).colorScheme.error),
                              const SizedBox(width: AppSize.xSmallSize),
                              Text(
                                AppLocalizations.of(context)!
                                    .reviewWidget_deleteReview,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          content: Text(
                            AppLocalizations.of(context)!
                                .reviewWidget_confirmDelete,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(AppLocalizations.of(context)!.cancel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSize.smallSize,
                                  vertical: AppSize.xxSmallSize,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.error,
                                  borderRadius: BorderRadius.circular(
                                    AppSize.xxSmallSize,
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.delete,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    if (confirm == true) {
                      widget.onDelete?.call();
                    }
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: AppSize.xSmallSize),
                        Text(AppLocalizations.of(context)!.edit),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete,
                            color: Theme.of(context).colorScheme.error),
                        const SizedBox(width: AppSize.xSmallSize),
                        Text(AppLocalizations.of(context)!.delete),
                      ],
                    ),
                  ),
                ],
                child: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSize.xSmallSize),
        if (isTextLong)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isExpanded ? text : '${text.substring(0, 100)}...',
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(
                  isExpanded
                      ? AppLocalizations.of(context)!.reviewWidget_readLess
                      : AppLocalizations.of(context)!.reviewWidget_readMore,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          )
        else
          Text(
            text,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
      ],
    );
  }
}
