import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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

		if (userUpdateInfo != null) {
			await _usuario.updateProfile(userUpdateInfo);
			_usuario = await _firebaseAuth.currentUser();
		}
		if (email != null) {
			await _usuario.updateEmail(email);
			_usuario = await _firebaseAuth.currentUser();
		}

		if (old_password != null)
			await _firebaseAuth.signInWithEmailAndPassword(
				email: _usuario.email,
				password: old_password
			);

		if (new_password != null)
			await _usuario.updatePassword(new_password);

		if (file != null)
			updatePhoto(file);

		_usuario = await _firebaseAuth.currentUser();

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
		if (_usuario != null) {
			try {
				_reference = _firebaseStorage.ref()
					.child(_usuario.photoUrl);
				await _reference.delete();
			} catch (e){}
			_reference = _firebaseStorage.ref()
				.child(
				"users/${_usuario.uid}_${Timestamp.now().microsecondsSinceEpoch}"
			);
			try {
				var path = file.absolute.path + Timestamp.now().toString();

				await FlutterImageCompress.compressAndGetFile(
					file.absolute.path, path,
					quality: 60,
					minHeight: 1920,
					minWidth: 1080,
				);
				file = await File(path);
			} catch (e){}
			await _reference.putFile(file).onComplete;
			var info = UserUpdateInfo();
			info.photoUrl = await _reference.getDownloadURL();
			await _usuario.updateProfile(info);
			_usuario = await _firebaseAuth.currentUser();
			notifyListeners();
		}
		return _usuario;
	}
}