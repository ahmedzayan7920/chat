
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialItem extends StatelessWidget {
  const SocialItem({
    super.key,
    required this.image,
    this.onTap,
  });
  final String image;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        image,
        width: 48,
        height: 48,
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.onSecondary,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
