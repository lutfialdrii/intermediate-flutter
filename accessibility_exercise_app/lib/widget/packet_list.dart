import 'package:accessibility_exercise_app/content/free_packet_card.dart';
import 'package:accessibility_exercise_app/content/or_widget.dart';
import 'package:accessibility_exercise_app/content/paid_packet_card.dart';
import 'package:accessibility_exercise_app/widget/max_width_widget.dart';
import 'package:flutter/material.dart';

class PackageList extends StatelessWidget {
  const PackageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isPotrait = orientation == Orientation.portrait;

    return MaxWidthWidget(
      maxWidth: 600,
      child: isPotrait
          ? Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                PaidPackageCard(),
                OrWidget(),
                FreePackageCard(),
              ],
            )
          : IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  Expanded(child: PaidPackageCard()),
                  OrWidget(),
                  Expanded(child: FreePackageCard()),
                ],
              ),
            ),
    );
  }
}
