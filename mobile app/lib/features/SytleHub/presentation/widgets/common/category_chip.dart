import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String name;
  final String image;
  final bool isSelected;
  final Function() onTap;

  const CategoryChip(
      {super.key,
      required this.name,
      required this.image,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width <= 280) {
      width = (width - (16 * 3)) / 2;
    } else if (width <= 340) {
      width = (width - (16 * 4)) / 3;
    } else if (width <= 450) {
      width = (width - (16 * 5)) / 4;
    } else if (width <= 550) {
      width = (width - (16 * 6)) / 5;
    } else if (width <= 650) {
      width = (width - (16 * 7)) / 6;
    } else if (width <= 700) {
      width = (width - (16 * 8)) / 7;
    } else {
      width = 80;
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: width,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    image,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.low,
                    cacheHeight: width.toInt(),
                    cacheWidth: width.toInt(),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.photo,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    size: width / 3,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
              ],
            ),
            Text(
              name,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
