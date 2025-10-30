import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/app_theme.dart';
import 'data/data_sources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository.dart';
import 'logic/auth/auth_bloc.dart';
import 'logic/auth/auth_event.dart';
import 'logic/auth/auth_state.dart';
import 'presentation/auth/login/login_screen.dart';
import 'presentation/home/home_screen.dart';
import 'presentation/splash/splash_screen.dart';


void main() {
  
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Create instances of your repository and its dependencies.
    // These will be singletons for the app's lifecycle.
    final authRepository = AuthRepository(
      dataSource: AuthRemoteDataSource(),
      storage: const FlutterSecureStorage(),
    );

    // 2. Provide the repository and BLoC to the widget tree.
    return RepositoryProvider.value(
      value: authRepository,
      child: BlocProvider(
        create: (context) => AuthBloc(authRepository: authRepository)
          ..add(AppStarted()), // Dispatch event to check for existing token
        child: MaterialApp(
          title: 'Crop Cure',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          // 3. Use a BlocBuilder to dynamically change the home screen
          // based on the authentication state.
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return const HomeScreen();
              }
              if (state is Unauthenticated) {
                return const LoginScreen();
              }
              // While the app is checking for a token, show a splash screen.
              return const SplashScreen();
            },
          ),
        ),
      ),
    );
  }
}

