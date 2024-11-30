import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/utils/captilizations.dart';
import '../../bloc/product/product_bloc.dart';

import '../../../../../setUp/size/app_size.dart';

class BrandPreference extends StatelessWidget {
  final Set<String> selectedBrands;
  final Function(String) onSelected;

  const BrandPreference(
      {super.key, required this.selectedBrands, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> brandNameMap = {
      'adidas': AppLocalizations.of(context)!.brand_adidas,
      'asics': AppLocalizations.of(context)!.brand_asics,
      'birkenstock': AppLocalizations.of(context)!.brand_birkenstock,
      'blundstone': AppLocalizations.of(context)!.brand_blundstone,
      'born / b.o.c.': AppLocalizations.of(context)!.brand_born_boc,
      'bulgari': AppLocalizations.of(context)!.brand_bulgari,
      'burberry': AppLocalizations.of(context)!.brand_burberry,
      'bzees': AppLocalizations.of(context)!.brand_bzees,
      'calvin klein': AppLocalizations.of(context)!.brand_calvin_klein,
      'cat': AppLocalizations.of(context)!.brand_cat,
      'chanel': AppLocalizations.of(context)!.brand_chanel,
      'clarks': AppLocalizations.of(context)!.brand_clarks,
      'columbia': AppLocalizations.of(context)!.brand_columbia,
      'crocs': AppLocalizations.of(context)!.brand_crocs,
      'dior': AppLocalizations.of(context)!.brand_dior,
      'dolce & gabbana': AppLocalizations.of(context)!.brand_dolce_gabbana,
      'dr martens': AppLocalizations.of(context)!.brand_dr_martens,
      'earth': AppLocalizations.of(context)!.brand_earth,
      'estee lauder': AppLocalizations.of(context)!.brand_estee_lauder,
      'eurosoft': AppLocalizations.of(context)!.brand_eurosoft,
      'fendi': AppLocalizations.of(context)!.brand_fendi,
      'florsheim': AppLocalizations.of(context)!.brand_florsheim,
      'gap': AppLocalizations.of(context)!.brand_gap,
      'givenchy': AppLocalizations.of(context)!.brand_givenchy,
      'gucci': AppLocalizations.of(context)!.brand_gucci,
      'h&m': AppLocalizations.of(context)!.brand_h_m,
      'hermès': AppLocalizations.of(context)!.brand_hermes,
      'hurly': AppLocalizations.of(context)!.brand_hurly,
      'jessica simpson': AppLocalizations.of(context)!.brand_jessica_simpson,
      'kamik': AppLocalizations.of(context)!.brand_kamik,
      'l\'oréal': AppLocalizations.of(context)!.brand_loreal,
      'lacoste': AppLocalizations.of(context)!.brand_lacoste,
      'levi\'s': AppLocalizations.of(context)!.brand_levis,
      'louis vuitton': AppLocalizations.of(context)!.brand_louis_vuitton,
      'mac cosmetics': AppLocalizations.of(context)!.brand_mac_cosmetics,
      'mephisto': AppLocalizations.of(context)!.brand_mephisto,
      'merrell': AppLocalizations.of(context)!.brand_merrell,
      'nike': AppLocalizations.of(context)!.brand_nike,
      'oofos': AppLocalizations.of(context)!.brand_oofos,
      'prada': AppLocalizations.of(context)!.brand_prada,
      'puma': AppLocalizations.of(context)!.brand_puma,
      'reebok': AppLocalizations.of(context)!.brand_reebok,
      'revlon': AppLocalizations.of(context)!.brand_revlon,
      'rockport': AppLocalizations.of(context)!.brand_rockport,
      'saucony': AppLocalizations.of(context)!.brand_saucony,
      'skechers': AppLocalizations.of(context)!.brand_skechers,
      'sorel': AppLocalizations.of(context)!.brand_sorel,
      'sperry': AppLocalizations.of(context)!.brand_sperry,
      'stacy adams': AppLocalizations.of(context)!.brand_stacy_adams,
      'teva': AppLocalizations.of(context)!.brand_teva,
      'timberland': AppLocalizations.of(context)!.brand_timberland,
      'tommy hilfiger': AppLocalizations.of(context)!.brand_tommy_hilfiger,
      'under armour': AppLocalizations.of(context)!.brand_under_armour,
      'vans': AppLocalizations.of(context)!.brand_vans,
      'versace': AppLocalizations.of(context)!.brand_versace,
      'viking': AppLocalizations.of(context)!.brand_viking,
      'zara': AppLocalizations.of(context)!.brand_zara,
    };
    return Column(
      children: [
        Text(
      AppLocalizations.of(context)!.preference_select_favorite_brands,
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
              children: [
                for (final brand in context.read<ProductBloc>().state.brands)
                  GestureDetector(
                    onTap: () {
                      onSelected(brand.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.xSmallSize,
                          vertical: AppSize.xxxSmallSize + 2),
                      margin: const EdgeInsets.all(AppSize.xSmallSize),
                      decoration: BoxDecoration(
                        color: selectedBrands.contains(brand.id)
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primaryContainer,
                        borderRadius:
                            BorderRadius.circular(AppSize.xxSmallSize),
                        border: Border.all(
                          color: selectedBrands.contains(brand.id)
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        Captilizations.capitalize(
                            brandNameMap[brand.name] ?? brand.name),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: selectedBrands.contains(brand.id)
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
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
