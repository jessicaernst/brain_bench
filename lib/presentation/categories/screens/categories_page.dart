import 'package:brain_bench/core/widgets/darkmode_btn.dart';
import 'package:brain_bench/core/widgets/lightmode_btn.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Assets.images.dashLogo.image(
                  width: 350,
                  height: 350,
                ),
              ),
              /* Text(
                AppLocalizations.of(context)!.appTitle,
                style: Theme.of(context).textTheme.displayMedium,
              ), */
              const SizedBox(height: 20),
              LightmodeBtn(
                title: 'test',
                onPressed: () {},
                //isActive: false,
              ),
              const SizedBox(height: 20),
              DarkmodeBtn(
                title: 'test',
                onPressed: () {},
                //isActive: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
