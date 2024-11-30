import 'features/product/presentation/bloc/product_bloc.dart';
import 'features/shop/presentation/bloc/shop_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'backgound_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/splash_screen.dart';
import 'features/shared/presentation/bloc/scroll/scroll_bloc.dart';
import 'features/shared/presentation/bloc/theme/theme_bloc.dart';
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
  ]).then((_) => runApp(const Starter()));
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
        BlocProvider(create: (context) => di.sl<AuthBloc>()),
        BlocProvider(create: (context) => di.sl<ProductBloc>()),
        BlocProvider(create: (context) => di.sl<ShopBloc>()),
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
        theme: LigthTheme.theme,
        darkTheme: DarkTheme.theme,
        themeMode: context.watch<ThemeBloc>().state.themeMode,
        home: const SplashScreen());
  }
}
