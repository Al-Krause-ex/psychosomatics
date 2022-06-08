import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psychosomatics/constants/routes_str.dart';
import 'package:psychosomatics/data/models/illness.dart';
import 'package:psychosomatics/data/repository.dart';
import 'package:psychosomatics/domain/cubit/auth_cubit.dart';
import 'package:psychosomatics/domain/cubit/logo_cubit.dart';
import 'package:psychosomatics/domain/cubit/user_cubit.dart';
import 'package:psychosomatics/presentation/screens/about_illness_screen.dart';
import 'package:psychosomatics/presentation/screens/diseases_screen.dart';
import 'package:psychosomatics/presentation/screens/error_screen.dart';
import 'package:psychosomatics/presentation/screens/illness_screen_cub.dart';
import 'package:psychosomatics/presentation/screens/logo_screen.dart';
import 'package:psychosomatics/presentation/screens/main_screen.dart';
import 'package:psychosomatics/presentation/screens/auth_screen.dart';
import 'package:psychosomatics/presentation/screens/subscription_screen.dart';
import 'package:psychosomatics/presentation/screens/verify_screen.dart';
import 'package:psychosomatics/presentation/screens/welcome_screen.dart';
import 'package:showcaseview/showcaseview.dart';

class AppRouter {
  final Repository repository;
  final UserCubit userCubit;
  final LogoCubit logoCubit;

  AppRouter({
    required this.repository,
    required this.userCubit,
    required this.logoCubit,
  });

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: logoCubit,
            child: const LogoScreen(),
          ),
        );
      case welcomeScreen:
        return MaterialPageRoute(
            builder: (_) => WelcomeScreen(
                  logoCubit: logoCubit,
                ));
      case authScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) =>
                AuthCubit(userCubit: userCubit, repository: repository),
            child: AuthScreen(),
          ),
        );

      // BlocProvider.value(
      //   value: blocProvider.favoriteCubit,
      //   child: FavoritePageCub(user: blocProvider.state.customUser!),
      // ),
      case illnessScreen:
        final groups = settings.arguments as List<TypeGroup>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: userCubit.illnessCubit,
            child: IllnessScreenCub(
              user: userCubit.state.customUser!,
              typeGroups: groups,
            ),
          ),
        );
      // case illnessScreen:
      //   final groups = settings.arguments as List<int>;
      //   return MaterialPageRoute(
      //     builder: (_) => IllnessScreen(
      //         customUser: userCubit.state.customUser!, groups: groups),
      //   );
      case verifyScreen:
        final authCubit = settings.arguments as AuthCubit;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: authCubit,
            // value: AuthCubit(userCubit: userCubit, repository: repository),
            child: VerifyScreen(
              authCubit: authCubit,
              // authCubit:
              //     AuthCubit(userCubit: userCubit, repository: repository),
              // isRegister: isRegister,
            ),
          ),
        );
      case mainScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: userCubit,
            child: ShowCaseWidget(
              onFinish: () {
                //userCubit
              },
              builder: Builder(builder: (ctx) => const MainScreen()),
              // child: const MainScreen(),
            ),
          ),
        );
      case diseasesScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: userCubit,
            child: const DiseasesScreen(),
          ),
        );
      case aboutIllnessScreen:
        final illness = settings.arguments as Illness;
        return MaterialPageRoute(
            builder: (_) =>
                AboutIllnessScreen(userCubit: userCubit, illness: illness));
      case subscriptionScreen:
        return MaterialPageRoute(builder: (_) => const SubscriptionScreen());
      default:
        return MaterialPageRoute(builder: (_) => const ErrorScreen());
    }
  }
}
