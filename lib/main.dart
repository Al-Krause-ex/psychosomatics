import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:psychosomatics/constants/icons_str.dart';
import 'package:psychosomatics/data/auth.dart';
import 'package:psychosomatics/data/repository.dart';
import 'package:psychosomatics/data/shared_preferences_tool.dart';
import 'package:psychosomatics/domain/cubit/favorites_cubit.dart';
import 'package:psychosomatics/domain/cubit/illness_cubit.dart';
import 'package:psychosomatics/domain/cubit/user_cubit.dart';
import 'package:psychosomatics/presentation/router.dart';

import 'domain/cubit/logo_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final repository = Repository(auth: Auth(), spTool: SharedPreferencesTool());

  final favoritesCubit = FavoritesCubit(repository);

  final userCubit = UserCubit(
    repository: repository,
    favoriteCubit: favoritesCubit,
    illnessCubit: IllnessCubit(repository, favoritesCubit),
  );

  runApp(HealthApp(
    router: AppRouter(
        repository: repository,
        userCubit: userCubit,
        logoCubit: LogoCubit(userCubit: userCubit, repository: repository)),
  ));
}

class HealthApp extends StatelessWidget {
  const HealthApp({Key? key, required this.router}) : super(key: key);

  final AppRouter? router;

  @override
  Widget build(BuildContext context) {
    precachePicture(
        SvgPicture.asset('assets/images/welcome_image.svg').pictureProvider,
        context);
    precachePicture(
        SvgPicture.asset('assets/images/auth_image.svg').pictureProvider,
        context);
    precachePicture(
        SvgPicture.asset('assets/images/profile_image.svg').pictureProvider,
        context);
    precachePicture(
        SvgPicture.asset('assets/images/verify_image.svg').pictureProvider,
        context);
    precachePicture(
        SvgPicture.asset('assets/images/heart_logo.svg').pictureProvider,
        context);

    precacheImage(const AssetImage(mainImage), context);
    precacheImage(const AssetImage(handIconMain), context);
    precacheImage(const AssetImage(legIconMain), context);
    precacheImage(const AssetImage(psycheIconMain), context);
    precacheImage(const AssetImage(neurologyIconMain), context);
    precacheImage(const AssetImage(infectionIconMain), context);
    precacheImage(const AssetImage(bodyIconMain), context);
    precacheImage(const AssetImage(otherIconMain), context);
    precacheImage(const AssetImage(headIconMain), context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SANITY',
      onGenerateRoute: router!.generateRoute,
      theme: ThemeData(primarySwatch: white),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
    );
  }
}

const MaterialColor white = MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);
