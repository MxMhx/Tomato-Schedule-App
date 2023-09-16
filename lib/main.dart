import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomato_schedule/bloc/bloc_observer.dart';
import 'package:tomato_schedule/bloc/blocs.dart';
import 'package:tomato_schedule/configs/config.dart';
import 'package:tomato_schedule/configs/theme.dart';
import 'package:tomato_schedule/screens/screens.dart';
import 'package:tomato_schedule/configs/app_route.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tomato_schedule/repositories/authentication_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const MyBlocObserver();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.remove(taskKey);
  FlutterSecureStorage storage = const FlutterSecureStorage();
  await storage.delete(key: userKey);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AuthenticationRepository _authenticationRepository;

  @override
  void initState() {
    _authenticationRepository = AuthenticationRepository();
    super.initState();
  }

  @override
  void dispose() {
    _authenticationRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
              value: (context) => _authenticationRepository),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (_) => AuthenticationBloc(
                    authenticationRepository: _authenticationRepository)),
            BlocProvider(
                create: (_) => LoginBloc(
                      authenticationRepository: _authenticationRepository,
                    )),
          ],
          child: AppView(AppRouter()),
        ));
  }
}

class AppView extends StatefulWidget {
  final AppRouter appRouter;
  const AppView(this.appRouter, {Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: widget.appRouter.onGenerateRoute,
      initialRoute: LoadingScreen.routeName,
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginFailed) {
              _navigator.pushNamedAndRemoveUntil<void>(
                LoginScreen.routeName,
                (route) => false,
              );
            }
          },
          child: BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              switch (state.status) {
                case AuthenticationStatus.authenticated:
                  _navigator.pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const NavBarView()),
                      (route) => false);
                  break;
                case AuthenticationStatus.unauthenticated:
                  _navigator.pushNamedAndRemoveUntil<void>(
                    LoginScreen.routeName,
                    (route) => false,
                  );
                  break;
                case AuthenticationStatus.unknown:
                  break;
              }
            },
            child: child,
          ),
        );
      },
    );
  }
}

class NavBarView extends StatefulWidget {
  const NavBarView({super.key});

  static const routeName = '/navbar';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const NavBarView(),
    );
  }

  @override
  State<NavBarView> createState() => _NavBarViewState();
}

class _NavBarViewState extends State<NavBarView> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    TaskDateScreen(),
    TimerScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.black,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.black,
            tabs: const [
              GButton(
                icon: Icons.home_filled,
                text: 'Home',
              ),
              GButton(
                icon: Icons.playlist_add_check,
                text: 'Task',
              ),
              GButton(
                icon: Icons.timelapse_sharp,
                text: 'Timer',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
