import 'package:edziennik/Screens/Authentication/register_page.dart';
import 'package:edziennik/Utils/fire_auth.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:edziennik/utils/validator.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  String _errorMessage = '';

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        FireAuth().authorizeAccess(context),
      );
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColors.darkGrey,
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 75.0),
                      Center(
                        child: Image(
                          image: AssetImage('assets/edziennik_logo_transparent.png'),
                        ),
                      ),
                      SizedBox(height: 50.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            myFormField(
                              _emailTextController,
                              'Email',
                              Icon(Icons.mail),
                              _focusEmail,
                              (value) => Validator.validateEmail(
                                email: value,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            myFormField(
                              _passwordTextController,
                              'Hasło',
                              Icon(Icons.vpn_key),
                              _focusPassword,
                              (value) => Validator.validatePassword(
                                password: value,
                              ),
                            ),
                            SizedBox(height: 50.0),
                            _isProcessing
                                ? CircularProgressIndicator()
                                : Column(
                                    children: <Widget>[
                                      applyButton(() async {
                                        _focusEmail.unfocus();
                                        _focusPassword.unfocus();

                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            _isProcessing = true;
                                          });
                                          User? user;
                                          try {
                                            user = await FireAuth.signInUsingEmailPassword(
                                              email: _emailTextController.text,
                                              password: _passwordTextController.text,
                                            );
                                            setState(() {
                                              _isProcessing = false;
                                            });
                                          } on UserNotFoundException catch (e) {
                                            setState(() {
                                              _errorMessage = e.errorMessage();
                                              _isProcessing = false;
                                            });
                                          } on WrongPasswordException catch (e) {
                                            setState(() {
                                              _errorMessage = e.errorMessage();
                                              _isProcessing = false;
                                            });
                                          } on LoginException catch (e) {
                                            setState(() {
                                              _errorMessage = e.errorMessage();
                                              _isProcessing = false;
                                            });
                                          }

                                          if (user != null) {
                                            FireAuth().authorizeAccess(context);
                                          }
                                        }
                                      }, 'Zaloguj'),
                                      SizedBox(height: 12.0),
                                      applyButton(() {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => RegisterPage(),
                                          ),
                                        );
                                      }, 'Stwórz konto'),
                                      SizedBox(height: 12.0),
                                      if (_errorMessage != '') errorMessageBox(),
                                    ],
                                  )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget myFormField(TextEditingController controller, String hintText, Icon prefixIcon, FocusNode fnode, FormFieldValidator<String> validator) {
    return TextFormField(
      controller: controller,
      focusNode: fnode,
      validator: validator,
      decoration: InputDecoration(
        fillColor: MyColors.frenchLime,
        hintText: hintText,
        filled: true,
        prefixIcon: prefixIcon,
        border: const OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: MyColors.carrotOrange),
        ),
        errorStyle: TextStyle(fontSize: 15.0),
      ),
    );
  }

  Widget applyButton(VoidCallback? onPress, String text) {
    return MaterialButton(
      onPressed: onPress,
      height: 50,
      minWidth: double.infinity,
      color: MyColors.dodgerBlue,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget errorMessageBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: MyColors.carrotOrange,
      child: ListTile(
        title: Text(
          _errorMessage,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: Icon(
          Icons.error,
          color: Colors.white,
        ),
        trailing: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () => setState(() {
                  _errorMessage = '';
                })),
      ),
    );
  }
}
