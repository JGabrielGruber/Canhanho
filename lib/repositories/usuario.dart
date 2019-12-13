import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
	final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
	static StorageReference _reference;
	static FirebaseUser _usuario;

	FirebaseUser get usuario => _usuario;

	UsuarioModel() {
		if (_usuario != null) {
			_reference = _firebaseStorage.ref()
				.child(
				"users/${_usuario.uid}"
			);
		}
	}

	Future<AuthResult> signIn(String email, String password) async {
		AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
			email: email,
			password: password
		);
		_usuario = result.user;
		notifyListeners();
		return result;
	}

	Future<AuthResult> signUp(
		String nome,
		String email,
		String password,
		File file
		) async {
		AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
			email: email,
			password: password
		);
		UserUpdateInfo info = UserUpdateInfo();
		info.displayName = nome;

		_usuario = result.user;
		await _usuario.updateProfile(info);
		if (file != null)
			updatePhoto(file);

		notifyListeners();
		return result;
	}

	Future<FirebaseUser> updateProfile(
		UserUpdateInfo userUpdateInfo,
		String email,
		String new_password,
		String old_password,
		File file
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
		print(file.path);
		if (file != null)
			updatePhoto(file);
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

	Future<FirebaseUser> updatePhoto(File file) async {
		if (_reference == null && _usuario != null) {
			_reference = _firebaseStorage.ref()
				.child(
				"users/${_usuario.uid}"
			);
		}
		await _reference.putFile(file).onComplete;
		var info = UserUpdateInfo();
		info.photoUrl = await _reference.getDownloadURL();
		print(info.photoUrl);
		await _usuario.updateProfile(info);
		print(_usuario.photoUrl);
		return _usuario;
	}
}