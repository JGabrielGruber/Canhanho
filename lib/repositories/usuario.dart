import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UsuarioModel extends ChangeNotifier {

	final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
	static FirebaseUser _usuario;

	FirebaseUser get usuario => _usuario;

	Future<AuthResult> signIn(String email, String password) async {
		AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
			email: email,
			password: password
		);
		_usuario = result.user;

		notifyListeners();
		return result;
	}

	Future<AuthResult> signUp(String nome, String email, String password) async {
		AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
			email: email,
			password: password
		);
		UserUpdateInfo info = UserUpdateInfo();
		info.displayName = nome;

		_usuario = result.user;
		_usuario.updateProfile(info);

		notifyListeners();
		return result;
	}

	Future<FirebaseUser> updateProfile(UserUpdateInfo userUpdateInfo) async {
		_usuario.updateProfile(userUpdateInfo);

		notifyListeners();
		return _usuario;
	}

	Future<bool> isSigned() async {
		_usuario = await _firebaseAuth.currentUser();
		if (_usuario != null) {
			return true;
		} else {
			return false;
		}
	}
}