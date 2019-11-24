import 'package:canhanho/repositories/base.dart';
import 'package:canhanho/repositories/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Despesa implements Base {
	final String uid;
	Timestamp data;
	String descricao;
	num valor;
	final DocumentReference reference;

	Despesa({
		this.data, this.descricao, this.valor,
		this.uid = null, this.reference = null
	});

	Despesa.fromMap(Map<String, dynamic> map, String id, {this.reference})
		:	assert(map['data'] != null),
			assert(map['descricao'] != null),
			assert(map['valor'] != null),
			uid			= id,
			data		= map['data'],
			descricao	= map['descricao'],
			valor		= map['valor'];

	Despesa.fromSnapshot(DocumentSnapshot snapshot)
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

class DespesaListModel extends ChangeNotifier implements BaseListModel {

	final Firestore _firestoreInstance = Firestore.instance;
	final UsuarioModel _usuario = UsuarioModel();

	final String _collection = "receitas";
	static CollectionReference _reference;
	static ObserverList<Despesa> _list = null;

	DespesaListModel() {
		if (_usuario.usuario != null) {
			_reference = _firestoreInstance
				.collection(
				"${_collection}/${_usuario.usuario.uid}/${_collection}"
			);
		}
	}

	Future<ObserverList<Despesa>> get() async {
		if (_reference == null) {
			_reference = _firestoreInstance
				.collection(
				"${_collection}/${_usuario.usuario.uid}/${_collection}"
			);
		}
		_list = await _reference.getDocuments().then((query) {
			return fromSnapshot(query.documents.toList());
		});
		notifyListeners();
		return _list;
	}

	Future<ObserverList<Despesa>> add(Base base) async {
		Despesa receita = base;
		_reference.add(receita.toMap());
		get();
		return _list;
	}

	Future<ObserverList<Despesa>> pop(Base base) async {
		Despesa receita = base;
		_reference.document(receita.uid).delete();
		get();
		return _list;
	}

	Future<ObserverList<Despesa>> update(Base base) async {
		Despesa receita = base;
		var dataMap = new Map<String, dynamic>();
		dataMap['valor'] = receita.valor;
		_reference.document(receita.uid).setData(receita.toMap());
		get();
		return _list;
	}

	ObserverList<Despesa> fromSnapshot(List<DocumentSnapshot> snapshots) {
		var list = ObserverList<Despesa>();
		snapshots.forEach((snapshot) {
			list.add(Despesa.fromSnapshot(snapshot));
		});
		return list;
	}

}