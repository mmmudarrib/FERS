import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/app_user.dart';
import '../services/user_local_data.dart';
import '../widgets/custom_toast.dart';
import 'user_api.dart';

class AuthMethods {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<bool> signinWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final UserCredential authResult = await _auth.signInWithCredential(
            GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken,
            ),
          );
          final User _user = authResult.user!;
          // TODO: need to be update
          final AppUser _appUser = AppUser(
            uid: _user.uid,
            name: _user.displayName!,
            email: _user.email!,
            imageURL: _user.photoURL!,
            timestamp: Timestamp.now().microsecondsSinceEpoch.toString(),
          );
          final bool _isOkay = await UserAPI().addUser(_appUser);
          if (_isOkay) {
            UserLocalData().storeAppUserData(appUser: _appUser);
          } else {
            return false;
          }
          return true;
        } catch (error) {
          CustomToast.errorToast(message: error.toString());
        }
      }
    }
    return false;
  }

  Future<User?> signupWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth
          .createUserWithEmailAndPassword(
        email: email.toLowerCase().trim(),
        password: password.trim(),
      )
          .catchError((Object obj) {
        CustomToast.errorToast(message: obj.toString());
      });
      final User? user = result.user;
      assert(user != null);
      return user;
    } catch (signUpError) {
      CustomToast.errorToast(message: signUpError.toString());
      return null;
    }
  }

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth
          .signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      )
          .catchError((Object obj) {
        CustomToast.errorToast(message: obj.toString());
      });
      final User? user = result.user;
      final AppUser appUser = await UserAPI().getInfo(uid: user!.uid);
      UserLocalData().storeAppUserData(appUser: appUser);
      return user;
    } catch (signUpError) {
      CustomToast.errorToast(message: signUpError.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    UserLocalData.signout();
    await _auth.signOut();
  }
}
