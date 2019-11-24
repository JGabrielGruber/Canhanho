import 'dart:ffi';

import 'package:canhanho/repositories/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

abstract class Base {
	final String uid;
	final DocumentReference reference;

	Base({this.uid, this.reference});

	Base.fromMap(Map<String, dynamic> map, String id, {this.reference})
		: uid = id;

	Base.fromSnapshot(DocumentSnapshot snapshot)
		: this.fromMap(null, null, reference: null);

	@override
	String toString() => "Base<$uid>";

}

abstract class BaseListModel extends ChangeNotifier {

	final Firestore _firestoreInstance = null;
	final UsuarioModel _usuario = null;

	final String _collection = null;
	static CollectionReference _reference = null;
	static ObserverList<Base> _list = null;

	Future<ObserverList<Base>> get() async {
		return _list;
	}

	Future<ObserverList<Base>> add(Base base) async {
		return _list;
	}

	Future<ObserverList<Base>> pop(Base base) async {
		return _list;
	}

	ObserverList<Base> fromSnapshot(List<DocumentSnapshot> snapshots) {
		return _list;
	}

}