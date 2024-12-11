import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/phone_link_or_update/phone_link_or_update_cubit.dart';

class PhoneBottomSheetHeader extends StatelessWidget {
  const PhoneBottomSheetHeader({
    super.key,
    required this.isLinking,
  });
  final bool isLinking;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              label: Text(
                'Change Number',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
              ),
              icon: Icon(
                Icons.change_circle_rounded,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              onPressed: () {
                context.read<PhoneLinkOrUpdateCubit>().emitInitial();
              },
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        Text(
          isLinking? 'Link your account with phone number': 'Update your phone number',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
