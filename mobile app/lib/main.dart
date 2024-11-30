import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:style_hub/features/SytleHub/presentation/bloc/general/general_bloc.dart';

import 'backgound_service.dart';
import 'features/SytleHub/presentation/bloc/chat/chat_bloc.dart';
import 'features/SytleHub/presentation/bloc/language/language_bloc.dart';
import 'features/SytleHub/presentation/bloc/notification/notification_bloc.dart';
import 'features/SytleHub/presentation/bloc/product/product_bloc.dart';
import 'features/SytleHub/presentation/bloc/product_filter/product_filter_bloc.dart';
import 'features/SytleHub/presentation/bloc/scroll/scroll_bloc.dart';
import 'features/SytleHub/presentation/bloc/shop/shop_bloc.dart';
import 'features/SytleHub/presentation/bloc/theme/theme_bloc.dart';
import 'features/SytleHub/presentation/bloc/user/user_bloc.dart';
import 'features/SytleHub/presentation/pages/splash_screen.dart';
import 'injection_container.dart' as di;
import 'setUp/service/local_cache.dart';
import 'setUp/theme/dark_theme.dart';
import 'setUp/theme/ligth_theme.dart';
import 'simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const SimpleBlocObserver();

  await di.init();
  await initializeService();
  await LocalCache.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(BlocProvider(
        create: (context) => di.sl<ChatBloc>(),
        child: const Starter(),
      )));
}

class Starter extends StatelessWidget {
  const Starter({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ScrollBloc(),
        ),
        BlocProvider(create: (context) => ProductFilterBloc()),
        BlocProvider(create: (context) => di.sl<ProductBloc>()),
        BlocProvider(create: (context) => di.sl<UserBloc>()),
        BlocProvider(create: (context) => di.sl<ShopBloc>()),
        BlocProvider(create: (context) => di.sl<NotificationBloc>()),
        BlocProvider(create: (context) => di.sl<GeneralBloc>()),
        BlocProvider(
          create: (context) => LanguageBloc(
            sharedPreferences: di.sl(),
          ),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(
            sharedPreferences: di.sl(),
          ),
        ),
      ],
      child: const App(),
    );
  }
}

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Afro Fashion",
        debugShowCheckedModeBanner: false,
        locale: context.watch<LanguageBloc>().state.locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('am', ''),
        ],
        theme: LigthTheme.theme,
        darkTheme: DarkTheme.theme,
        themeMode: context.watch<ThemeBloc>().state.themeMode,
        home: const SplashScreen());
  }
}
