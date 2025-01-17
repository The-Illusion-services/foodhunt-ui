import 'package:food_hunt/providers/app_state.dart';
import 'package:food_hunt/providers/auth_provider.dart';
import 'package:food_hunt/screens/app/user/home/home_screen.dart';
import 'package:food_hunt/screens/auth/login/view/login.dart';
import 'package:food_hunt/screens/auth/sign_up.dart';
import 'package:food_hunt/screens/onboarding/onboarding.dart';
import 'package:food_hunt/widgets/main_tab_scaffold.dart';
import 'package:food_hunt/widgets/tab_wrapper.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(authProvider);
  final isOnboardingComplete = ref.watch(appStateProvider).isOnboardingComplete;

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (!isOnboardingComplete) {
        return '/onboarding';
      }
      if (!isLoggedIn && state.matchedLocation != '/login') {
        return '/login';
      }
      return null;
    },
    routes: [
      GoRoute(
          path: '/onboarding', builder: (context, state) => OnboardingScreen()),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/sign_up', builder: (context, state) => SignUpScreen()),
      GoRoute(
        path: '/sign_up',
        builder: (context, state) => SignUpScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainTabScaffold(child: child),
        routes: [
          ShellRoute(
            builder: (context, state, child) =>
                TabWrapper(child: child, index: 0),
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => HomeScreen(),
                // routes: [
                //   GoRoute(
                //     path: 'details',
                //     builder: (context, state) => HomeDetailsScreen(),
                //   ),
                // ],
              ),
            ],
          ),
          ShellRoute(
            builder: (context, state, child) =>
                TabWrapper(child: child, index: 1),
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => HomeScreen(),
                // routes: [
                //   GoRoute(
                //     path: 'results',
                //     builder: (context, state) => SearchResultsScreen(),
                //   ),
                // ],
              ),
            ],
          ),
          ShellRoute(
            builder: (context, state, child) =>
                TabWrapper(child: child, index: 2),
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => HomeScreen(),
                // routes: [
                //   GoRoute(
                //     path: 'edit',
                //     builder: (context, state) => ProfileEditScreen(),
                //   ),
                // ],
              ),
            ],
          ),
          ShellRoute(
            builder: (context, state, child) =>
                TabWrapper(child: child, index: 3),
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => HomeScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
