import 'package:firebase_auth/firebase_auth.dart';
import 'package:firechat/api/chat_api.dart';
import 'package:firechat/model/user.dart' as u;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginApi {
  late final FirebaseAuth auth;

  LoginApi() {
    auth = FirebaseAuth.instance;
  }

  void loginWithGoogle({required BuildContext context}) async {
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    await auth.signInWithCredential(credential).then((value) {
      ChatApi().addList(
          user: u.User(
              uid: auth.currentUser!.uid,
              email: auth.currentUser!.email!,
              name: auth.currentUser!.displayName!,
              pic_link: googleSignInAccount.photoUrl!));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Logged In!!')));
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('/chat');
    }).catchError((onError) {
      print(onError);
    });
  }

  void signupWithEmail(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        ChatApi().addList(
            user: u.User(
                uid: auth.currentUser!.uid,
                email: auth.currentUser!.email!,
                name: auth.currentUser!.displayName!));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Logged In!!')));
        Navigator.of(context).pushNamed('/chat');
      }).catchError((onError) {
        print(onError);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void loginWithEmail(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Logged In!!')));
        Navigator.of(context).pushNamed('/chat');
      }).catchError((onError) {
        print(onError);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void login({required String mobile, required BuildContext context}) async {
    try {
      auth.verifyPhoneNumber(
          phoneNumber: mobile,
          timeout: Duration(seconds: 20),
          verificationCompleted: (phoneAuthCredential) async {
            await auth.signInWithCredential(phoneAuthCredential).then((value) {
              ChatApi().addList(
                  user: u.User(
                      uid: auth.currentUser!.uid,
                      email: auth.currentUser!.phoneNumber!,
                      name: auth.currentUser!.displayName!));
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Logged In!!')));
              Navigator.of(context).pushNamed('/chat');
            }).catchError((onError) {
              print(onError);
            });
          },
          verificationFailed: (e) {
            print(e.message);
          },
          codeSent: (verificationId, [resendId]) {
            var _otp = TextEditingController();
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('OTP'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _otp,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      var code = _otp.text.trim();
                      var credential = PhoneAuthProvider.credential(
                          verificationId: verificationId, smsCode: code);
                      await auth.signInWithCredential(credential).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Logged In!!')));
                        Navigator.of(context).pushNamed('/chat');
                      }).catchError((onError) {
                        print(onError);
                      });
                      _otp.dispose();
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(
                          color: Colors.blue, backgroundColor: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {
            print(verificationId);
          });
    } catch (e) {
      print(e.toString());
    }
  }
}
