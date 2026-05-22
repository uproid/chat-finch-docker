import 'package:chat/db/users.dart';
import 'package:chat/forms/login_form.dart';
import 'package:chat/forms/register_form.dart';
import 'package:chat/models/user.dart';
import 'package:finch/finch_route.dart';
import 'package:finch/finch_tools.dart';

class AppAuthController extends AuthController<User> {
  AppAuthController();
  UsersTable usersTable = UsersTable();

  Future<User?> getLoggedInUser() async {
    var login = await checkLogin();
    if (login.success) {
      return login.user;
    }
    return null;
  }

  @override
  Future<bool> auth() async {
    var login = await checkLogin();
    if (login.success) {
      rq.assetManager.addData({
        'user': login.user!.fields.removeAll(['password', 'login_secret']),
      });
      return true;
    }

    rq.redirect('/login');
    return false;
  }

  @override
  Future<bool> authApi() {
    throw UnimplementedError();
  }

  @override
  Future<({String message, bool success, User? user})> checkLogin() async {
    // Check by cookie
    var loginCookie = rq.getCookie('chat_secret', def: '', safe: true).trim();
    if (loginCookie.isEmpty) {
      return (message: 'No login cookie found', success: false, user: null);
    }
    //loginCookie = loginCookie.fromSafe(MainConfigs.safePassword);
    var user = await usersTable.getUserBySecret(loginCookie);
    if (user == null) {
      return (message: 'Invalid login cookie', success: false, user: null);
    }

    return (
      message: 'Login cookie found',
      success: true,
      user: user,
    );
  }

  @override
  Future<bool> checkPermission() async {
    return true;
  }

  @override
  Future<String> loginPost() async {
    LoginForm loginForm = LoginForm();

    if (loginForm.isSubmitted()) {
      await loginForm.check(
        onValid: (form) async {
          var username = loginForm.get<String>('username');
          var password = loginForm.get<String>('password');
          var user = await usersTable.getUser(username, password);
          if (user == null) {
            form['password']['error'] = 'Invalid username or password';
            form['password']['success'] = false;
          } else {
            final secret = await usersTable.setSecretLogin(username);
            updateAuthSecret(secret, user);
            rq.redirect('/');
          }
        },
      );
    }

    return rq.renderView(path: 'login');
  }

  @override
  Future<String> logout() {
    removeAuth();
    return rq.redirect('/');
  }

  @override
  Future<String> newUser() {
    throw UnimplementedError();
  }

  @override
  Future<String> register() async {
    RegisterForm registerForm = RegisterForm();
    if (registerForm.isSubmitted()) {
      await registerForm.check(
        onValid: (form) async {
          var password = registerForm.get<String>('password');
          var email = registerForm.get<String>('email');
          var username = registerForm.get<String>('username');

          final res = await usersTable.newUser(
            email: email,
            username: username,
            password: password,
          );

          if (res.success) {
            rq.redirect('/');
          } else {
            form['email']['error'] = res.errorMsg;
            form['email']['success'] = false;
          }
        },
      );
    }
    return rq.renderView(path: 'register');
  }

  @override
  void removeAuth() {
    rq.removeCookie('chat_secret');
  }

  @override
  void updateAuth(String email, String password, User user) {
    throw UnimplementedError('Use updateAuthSecret instead');
  }

  void updateAuthSecret(String secret, User user) {
    rq.addCookie('chat_secret', secret, safe: true);
  }
}
