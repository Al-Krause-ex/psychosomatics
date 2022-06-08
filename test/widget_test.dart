// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psychosomatics/data/auth.dart';
import 'package:psychosomatics/data/repository.dart';
import 'package:psychosomatics/data/shared_preferences_tool.dart';
import 'package:psychosomatics/domain/cubit/favorites_cubit.dart';
import 'package:psychosomatics/domain/cubit/illness_cubit.dart';
import 'package:psychosomatics/domain/cubit/logo_cubit.dart';
import 'package:psychosomatics/domain/cubit/user_cubit.dart';

import 'package:psychosomatics/main.dart';
import 'package:psychosomatics/presentation/router.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final repository =
        Repository(auth: Auth(), spTool: SharedPreferencesTool());
    final favoritesCubit = FavoritesCubit(repository);

    final userCubit = UserCubit(
      repository: repository,
      favoriteCubit: favoritesCubit,
      illnessCubit: IllnessCubit(repository, favoritesCubit),
    );

    await tester.pumpWidget(HealthApp(
      router: AppRouter(
        repository: repository,
        userCubit: userCubit,
        logoCubit: LogoCubit(repository: repository, userCubit: userCubit),
      ),
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
