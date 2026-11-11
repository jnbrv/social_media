import 'package:flutter/material.dart';
import 'package:social_media/auth/register.dart';

import 'local_auth.dart';
import '../model/userdata.dart';
import '../socialmedia.dart';

class LoginForm extends StatefulWidget {
  final String? initialUsername;

  const LoginForm({super.key, this.initialUsername});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  String? errorMessage;
  bool hidePassword = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    usernameController.text = widget.initialUsername ?? '';
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> checkLogin() async {
    if (usernameController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please enter your username and password.';
      });
      return;
    }

    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    final user = await LocalAuthService.login(
      identifier: usernameController.text,
      password: passwordController.text,
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    if (user == null) {
      setState(() {
        errorMessage = 'Invalid username/email or password.';
      });
      return;
    }

    final userdata = Userdata(displayName: user.fullName, email: user.email);

    await userdata.loadComments();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Socialmedia(userdata: userdata)),
    );
  }

  Future<void> openRegistration() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const RegisterForm()),
    );

    if (!mounted) return;

    if (result != null) {
      usernameController.text = result;
      passwordController.clear();
      setState(() {
        errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.people_alt_rounded,
                  size: 75,
                  color: Colors.indigo,
                ),

                const SizedBox(height: 12),

                const Text(
                  'PisBook',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Connect with your friends!',
                  style: TextStyle(color: Colors.black54),
                ),

                const SizedBox(height: 30),

                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Username or Email',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => checkLogin(),
                ),

                if (errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : checkLogin,
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('LOGIN'),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                const Text("Don't have an account?"),

                TextButton(
                  onPressed: openRegistration,
                  child: const Text(
                    'CREATE AN ACCOUNT',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Developed by BRAVO',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
