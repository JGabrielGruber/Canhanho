import 'package:canhanho/repositories/despesa.dart';
import 'package:canhanho/widgets/base_controle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DespesasScreen extends StatefulWidget {
	@override
	_DespesasScreenState createState() => _DespesasScreenState();
}

class _DespesasScreenState extends State<DespesasScreen> {
	@override
	Widget build(BuildContext context) {

		return ControleBase(
			stream: Provider.of<DespesaListModel>(context, listen: false).get().asStream(),
			onAdd: Provider.of<DespesaListModel>(context).add,
			onUpdate: Provider.of<DespesaListModel>(context).update,
			type: () => Despesa(),
		);
	}
}