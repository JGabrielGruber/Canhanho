import 'package:canhanho/repositories/base.dart';
import 'package:canhanho/repositories/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Receita implements Base {
	final String uid;
	Timestamp data;
	String descricao;
	num valor;
	final DocumentReference reference;

	Receita({
		this.data, this.descricao, this.valor,
		this.uid = null, this.reference = null
	});

	Receita.fromMap(Map<String, dynamic> map, String id, {this.reference})
		:	assert(map['data'] != null),
			assert(map['descricao'] != null),
			assert(map['valor'] != null),
			uid			= id,
			data		= map['data'],
			descricao	= map['descricao'],
			valor		= map['valor'];

	Receita.fromSnapshot(DocumentSnapshot snapshot)
		: this.fromMap(snapshot.data, snapshot.documentID, reference: snapshot.reference);

	Map<String, dynamic> toMap() {
		var dataMap = new Map<String, dynamic>();
		dataMap['data'] = this.data;
		dataMap['descricao'] = this.descricao;
		dataMap['valor'] = this.valor;
		return dataMap;
	}

	@override
	String toString() => "Receita<$uid:$valor>";

}

class ReceitaListModel extends ChangeNotifier implements BaseListModel {

	final Firestore _firestoreInstance = Firestore.instance;
	final UsuarioModel _usuario = UsuarioModel();

	final String _collection = "receitas";
	static CollectionReference _reference;
	static ObserverList<Receita> _list = null;

	ReceitaListModel() {
		if (_usuario.usuario != null) {
			_reference = _firestoreInstance
				.collection(
				"${_collection}/${_usuario.usuario.uid}/${_collection}"
			);
		}
	}

	Future<ObserverList<Receita>> get() async {
		if (_reference == null) {
			_reference = _firestoreInstance
				.collection(
					"${_collection}/${_usuario.usuario.uid}/${_collection}"
				);
		}
		_list = await _reference.orderBy("data").getDocuments().then((query) {
			return fromSnapshot(query.documents.toList());
		});
		notifyListeners();
		return _list;
	}

	Future<ObserverList<Receita>> add(Base base) async {
		Receita receita = base;
		_reference.add(receita.toMap());
		get();
		return _list;
	}

	Future<ObserverList<Receita>> pop(Base base) async {
		Receita receita = base;
		_reference.document(receita.uid).delete();
		get();
		return _list;
	}

	Future<ObserverList<Receita>> update(Base base) async {
		Receita receita = base;
		var dataMap = new Map<String, dynamic>();
		dataMap['valor'] = receita.valor;
		_reference.document(receita.uid).setData(receita.toMap());
		get();
		return _list;
	}

	ObserverList<Receita> fromSnapshot(List<DocumentSnapshot> snapshots) {
		var list = ObserverList<Receita>();
		snapshots.forEach((snapshot) {
			list.add(Receita.fromSnapshot(snapshot));
		});
		return list;
	}

}