import 'package:canhanho/repositories/base.dart';
import 'package:canhanho/repositories/receita.dart';
import 'package:canhanho/widgets/form_popup.dart';
import 'package:canhanho/widgets/tabela.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ControleBase extends StatefulWidget {
	final Function onUpdate, onAdd;
	final Stream<ObserverList<Base>> stream;
	final type;


	ControleBase({this.onUpdate, this.onAdd, this.stream, this.type});

	@override
	_ControleBaseState createState() => _ControleBaseState();
}

class _ControleBaseState extends State<ControleBase> {
	@override
	Widget build(BuildContext context) {

		Future<void> _showForm({Base item = null}) async {
			return showDialog<void>(
				context: context,
				barrierDismissible: true,
				builder: (BuildContext context) {
					if (item == null)
						return FormBase(
							updateInfo: widget.onAdd,
							isEdit: false,
							base: widget.type(),
						);
					return FormBase(
						updateInfo: widget.onUpdate,
						isEdit: true,
						base: item,
					);
				},
			);
		}

		return Scaffold(
			resizeToAvoidBottomPadding: false,
			body: SingleChildScrollView(
				child: Column(
					children: <Widget>[
						StreamBuilder(
							stream: widget.stream,
							builder: (context, snapshot) {
								if (snapshot.data != null)
									return TableBase(
										source: snapshot.data.toList(),
										onSelected: (Base base) {
											_showForm(item: base);
										}
									);
								else
									return Center(
										child: Text(""),
									);
							}
						),
						Padding(padding: EdgeInsets.all(30))
					],
				),
			),
			floatingActionButton: FloatingActionButton(
				child: Icon(Icons.add),
				onPressed: _showForm,
				backgroundColor: widget.type() is Receita ? Colors.green : Colors.red,
			),
		);
	}
}