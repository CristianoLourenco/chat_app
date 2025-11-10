import 'package:chat/firebase_options.dart';
import 'package:chat/util/validation_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  String _enteredPassword = "";
  String _enteredEmail = "";
  String _enteredUsername = "";
  bool isLoading = false;

  static final _firebase = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    try {
      if (!isValid) return;
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });

      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        await FirebaseFirestore.instanceFor(
          app: _firebase.app,
        ).collection('users').doc(userCredentials.user?.uid).set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'image_url': '....',
        });
      }
      return;
    } on FirebaseAuthException catch (error) {
      if (error.message == "email-already-in-use") {}
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? "Fail on Auth, try again later"),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fail on Auth, try again later $e")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset("assets/images/chat.png"),
              ),

              Card(
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            onSaved: (newValue) {
                              _enteredEmail = newValue ?? "";
                            },
                            decoration: InputDecoration(
                              labelText: "Email Address",
                            ),
                            validator: ValidationUtil.email,
                          ),
                          if (!_isLogin)
                            TextFormField(
                              keyboardType: TextInputType.name,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              onSaved: (newValue) {
                                _enteredUsername = newValue ?? "";
                              },
                              decoration: InputDecoration(
                                labelText: "username",
                              ),
                              validator: ValidationUtil.username,
                            ),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            onSaved: (newValue) {
                              _enteredPassword = newValue ?? "";
                            },
                            decoration: InputDecoration(labelText: "Password"),
                            validator: ValidationUtil.password,
                          ),
                          SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                            ),
                            child:
                                isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : Text(_isLogin ? 'Login' : "Signup"),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin
                                  ? "Create an account"
                                  : "I already have an account",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
