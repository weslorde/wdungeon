import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wdungeon/pesquisa_page.dart';
import 'package:wdungeon/sorteio_page.dart';
import 'package:wdungeon/tdherois_page.dart';

void main() {
  runApp(const MyApp());
}

///
/// ROTAS
///
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppLayout(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const TdHerois(),
        ),
        GoRoute(
          path: '/pesquisa',
          builder: (context, state) => const PesquisaHerois(),
        ),
        GoRoute(
          path: '/sorteio',
          builder: (context, state) => const SorteioHeroi(),
        ),
      ],
    ),
  ],
);

///
/// APP
///
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WDungeon',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
    );
  }
}

///
/// LAYOUT PADRÃO
///
class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: const AppTopBar(),
      body: child,
      bottomNavigationBar: const AppBottomBar(),
    );
  }
}

///
/// TOPO
///
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: const Text(
        "Meu Projeto",
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

///
/// BARRA INFERIOR
///
class AppBottomBar extends StatelessWidget {
  const AppBottomBar({super.key});

  int currentIndex(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    switch (path) {
      case '/':
        return 0;
      case '/pesquisa':
        return 1;
      case '/sorteio':
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex(context),

      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/');
            break;

          case 1:
            context.go('/pesquisa');
            break;

          case 2:
            context.go('/sorteio');
            break;
        }
      },

      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.person),
          selectedIcon: Icon(Icons.person),
          label: "Todos",
        ),
        NavigationDestination(
          icon: Icon(Icons.search),
          selectedIcon: Icon(Icons.search),
          label: "Pesquisa",
        ),
        NavigationDestination(
          icon: Icon(Icons.casino),
          selectedIcon: Icon(Icons.casino),
          label: "Random",
        ),
      ],
    );
  }
}


