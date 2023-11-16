import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordInvisible = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _saveCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);
  }

  void _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('email') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccessState) {
                Navigator.of(context).pushReplacementNamed('/surveyPage');
              } else if (state is AuthErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                  ),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Header
                Text(
                  'Login to Synapsis',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 24,
                ),
                //Form
                Form(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Email
                    Text('Email'),
                    SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                          hintText: 'Masukan Email',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(4)),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    //Password
                    Text('Password'),
                    SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _passwordInvisible,
                      decoration: InputDecoration(
                        hintText: 'Masukan Password',
                        contentPadding: EdgeInsets.all(4),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordInvisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordInvisible = !_passwordInvisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // Remmember me
                    Row(
                      children: [
                        Checkbox(
                          value: _passwordInvisible,
                          onChanged: (value) {
                            setState(() {
                              _passwordInvisible = value!;
                              if (value) {
                                _saveCredentials(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              }
                            });
                          },
                        ),
                        const Text('Remember me'),
                      ],
                    ),
                    //Tombol Login
                    SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                            onPressed: () {
                              authBloc.add(LoginEvent(
                                email: _emailController.text,
                                password: _passwordController.text,
                              ));
                            },
                            child: Text('Log In'))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Center(
                        child: Text(
                          'Or',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.blue),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Fingerprint feature is not available yet'),
                                ),
                              );
                            },
                            child: Text('FingerPrint'))),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
