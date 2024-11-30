import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../bloc/product/product_bloc.dart';

import '../../../../../core/utils/captilizations.dart';
import '../../../../../setUp/size/app_size.dart';

class ColorPreference extends StatelessWidget {
  final Set<String> selectedColors;
  final Function(String) onSelected;

  const ColorPreference(
      {super.key, required this.selectedColors, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> colorNameMap = {
      'beige': AppLocalizations.of(context)!.color_beige,
      'black': AppLocalizations.of(context)!.color_black,
      'blue': AppLocalizations.of(context)!.color_blue,
      'blush pink': AppLocalizations.of(context)!.color_blush_pink,
      'brown': AppLocalizations.of(context)!.color_brown,
      'burgundy': AppLocalizations.of(context)!.color_burgundy,
      'champagne': AppLocalizations.of(context)!.color_champagne,
      'charcoal': AppLocalizations.of(context)!.color_charcoal,
      'cobalt blue': AppLocalizations.of(context)!.color_cobalt_blue,
      'coral': AppLocalizations.of(context)!.color_coral,
      'coral red': AppLocalizations.of(context)!.color_coral_red,
      'cream': AppLocalizations.of(context)!.color_cream,
      'crimson': AppLocalizations.of(context)!.color_crimson,
      'emerald green': AppLocalizations.of(context)!.color_emerald_green,
      'gold': AppLocalizations.of(context)!.color_gold,
      'gray': AppLocalizations.of(context)!.color_gray,
      'green': AppLocalizations.of(context)!.color_green,
      'indigo': AppLocalizations.of(context)!.color_indigo,
      'ivory': AppLocalizations.of(context)!.color_ivory,
      'khaki': AppLocalizations.of(context)!.color_khaki,
      'lavender': AppLocalizations.of(context)!.color_lavender,
      'maroon': AppLocalizations.of(context)!.color_maroon,
      'mauve': AppLocalizations.of(context)!.color_mauve,
      'midnight blue': AppLocalizations.of(context)!.color_midnight_blue,
      'mint green': AppLocalizations.of(context)!.color_mint_green,
      'mustard yellow': AppLocalizations.of(context)!.color_mustard_yellow,
      'navy blue': AppLocalizations.of(context)!.color_navy_blue,
      'neon green': AppLocalizations.of(context)!.color_neon_green,
      'olive': AppLocalizations.of(context)!.color_olive,
      'orange': AppLocalizations.of(context)!.color_orange,
      'pastel peach': AppLocalizations.of(context)!.color_pastel_peach,
      'pink': AppLocalizations.of(context)!.color_pink,
      'platinum': AppLocalizations.of(context)!.color_platinum,
      'purple': AppLocalizations.of(context)!.color_purple,
      'red': AppLocalizations.of(context)!.color_red,
      'rose gold': AppLocalizations.of(context)!.color_rose_gold,
      'rust': AppLocalizations.of(context)!.color_rust,
      'sapphire blue': AppLocalizations.of(context)!.color_sapphire_blue,
      'silver': AppLocalizations.of(context)!.color_silver,
      'slate': AppLocalizations.of(context)!.color_slate,
      'tan': AppLocalizations.of(context)!.color_tan,
      'teal': AppLocalizations.of(context)!.color_teal,
      'turquoise': AppLocalizations.of(context)!.color_turquoise,
      'white': AppLocalizations.of(context)!.color_white,
      'yellow': AppLocalizations.of(context)!.color_yellow,
    };
    return Column(
      children: [
        Text(
         AppLocalizations.of(context)!.preference_select_favorite_colors,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.2,
              ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: AppSize.mediumSize),
        SizedBox(
          height: 340,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              spacing: AppSize.mediumSize,
              runSpacing: AppSize.mediumSize,
              children: [
                for (final color in context.read<ProductBloc>().state.colors)
                  GestureDetector(
                    onTap: () {
                      onSelected(color.id);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Color(int.parse(
                              "FF${color.hexCode.substring(1)}",
                              radix: 16,
                            )),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: selectedColors.contains(color.id)
                              ? Center(
                                  child: Icon(
                                    Icons.check,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    size: 16,
                                  ),
                                )
                              : null,
                        ),
                        Text(
                          Captilizations.capitalize(
                              colorNameMap[color.name] ?? color.name),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSize.smallSize),
      ],
    );
  }
}
