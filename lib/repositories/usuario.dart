import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class User implements UserInfo {
	String email = "";
	String displayName = "";
	String providerId = "";
	String uid = "";
	String phoneNumber = "";
	String photoUrl = "";
}

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

	Future<FirebaseUser> updateProfile(
		UserUpdateInfo userUpdateInfo,
		String email,
		String new_password,
		String old_password
	) async {
		_usuario.updateProfile(userUpdateInfo);
		if (email != null)
			await _usuario.updateEmail(email);
		if (old_password != null)
			await _firebaseAuth.signInWithEmailAndPassword(
				email: _usuario.email,
				password: old_password
			);
		if (new_password != null)
			_usuario.updatePassword(new_password);

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

	Future<void> signOut() async {
		return _firebaseAuth.signOut();
	}
}