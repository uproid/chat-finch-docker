import 'package:chat/controllers/workspace_controller.dart';
import '../controllers/auth_controller.dart';
import 'package:finch/finch_route.dart';
import '../controllers/home_controller.dart';

final homeController = HomeController();
final authController = AppAuthController();
final includeController = IncludeJsController();
final workspaceController = WorkspaceController();

Future<List<FinchRoute>> getWebRoute(Request rq) async {
  var paths = <FinchRoute>[
    FinchRoute(
      path: '/',
      methods: Methods.ALL,
      index: homeController.index,
      auth: authController,
    ),
    FinchRoute(
      path: '/login',
      methods: Methods.GET_POST,
      index: authController.loginPost,
    ),
    FinchRoute(
      path: '/logout',
      methods: Methods.GET_POST,
      index: authController.logout,
    ),
    FinchRoute(
      path: '/register',
      methods: Methods.GET_POST,
      index: authController.register,
    ),
    FinchRoute(
      path: 'workspace',
      methods: Methods.ALL,
      auth: authController,
      index: workspaceController.index,
    ),
    FinchRoute(
      path: '/ws',
      methods: Methods.ALL,
      index: homeController.socket,
      auth: authController,
    ),
    FinchRoute(
      path: '/app/includes.js',
      methods: Methods.ALL,
      controller: includeController,
    )
  ];

  return paths;
}
