import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jameia/core/config/routing/app_router.dart';
import 'package:jameia/core/config/theme/app_theme.dart';
import 'package:jameia/core/di/service_locator.dart' as di;
import 'package:jameia/core/presentation/cubits/theme_cubit/theme_cubit.dart';
import 'package:jameia/features/recipes/presentation/blocs/recipes/recipes_bloc.dart';
import 'package:jameia/features/recipes/presentation/screens/recipes_screen.dart';


class JameiaApp extends StatelessWidget {
  const JameiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<ThemeCubit>()),
        BlocProvider(
          create: (_) => di.sl<RecipesBloc>()..add(FetchRecipes()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'jameia',
            theme: AppTheme.getTheme(context, Brightness.light),
            darkTheme: AppTheme.getTheme(context, Brightness.dark),
            themeMode: state.themeMode,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.onGenerateRoute,
            home: const RecipesScreen(),
          );
        },
      ),
    );
  }
}
