import 'package:canhanho/repositories/receita.dart';
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
			stream: Provider.of<ReceitaListModel>(context).get().asStream(),
			onAdd: Provider.of<ReceitaListModel>(context).add,
			onUpdate: Provider.of<ReceitaListModel>(context).update,
			type: () => Receita(),
		);
	}
}