import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/phone_link/phone_link_cubit.dart';

class PhoneLinkBottomSheetHeader extends StatelessWidget {
  const PhoneLinkBottomSheetHeader({
    super.key,
  });

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
                context.read<PhoneLinkCubit>().emitInitial();
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
          'Link your account with phone number',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}