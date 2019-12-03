import 'package:canhanho/repositories/despesa.dart';
import 'package:canhanho/widgets/base_controle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceitasScreen extends StatefulWidget {
  @override
  _ReceitasScreenState createState() => _ReceitasScreenState();
}

class _ReceitasScreenState extends State<ReceitasScreen> {
	@override
	Widget build(BuildContext context) {

		return ControleBase(
			stream: Provider.of<DespesaListModel>(context).get().asStream(),
			onAdd: Provider.of<DespesaListModel>(context).add,
			onUpdate: Provider.of<DespesaListModel>(context).update,
			type: () => Despesa(),
		);
	}
}