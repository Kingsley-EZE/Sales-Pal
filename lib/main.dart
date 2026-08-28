import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/connectivity/connectivity_cubit.dart';
import 'core/di/injection.dart';
import 'core/navigation/app_router.dart';
import 'design/theme.dart';
import 'features/orders/presentation/cubit/order_draft_cubit.dart';
import 'features/orders/presentation/cubit/submit_order_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  unawaited(getIt<ConnectivityCubit>().watch());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<OrderDraftCubit>()),
        BlocProvider.value(value: getIt<SubmitOrderCubit>()),
        BlocProvider.value(value: getIt<ConnectivityCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Sales Pal',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
