import 'package:canhanho/repositories/base.dart';
import 'package:canhanho/repositories/despesa.dart';
import 'package:canhanho/repositories/receita.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class FormBase extends StatefulWidget {

	final Base base;
	final Function updateInfo;
	final bool isEdit;
	final format = DateFormat("yyyy-MM-dd HH:mm");

	FormBase({this.base, this.updateInfo, this.isEdit = false});

	@override
	_FormBaseState createState() => _FormBaseState();
}

class _FormBaseState extends State<FormBase> {

	final _formKey = GlobalKey<FormState>();

	final MoneyMaskedTextController _valorController = new MoneyMaskedTextController(leftSymbol: 'R\$ ');
	final TextEditingController	_descricaoController = TextEditingController();
	final TextEditingController _dataController = TextEditingController();

	@override
	Widget build(BuildContext context) {
		 return AlertDialog(
			title: Text('Adicionar Despesa'),
			content: SingleChildScrollView(
				child: SafeArea(
					child: Container(
						child: Column(
							children: <Widget>[
								Form(
									key: _formKey,
									child: Column(
										children: <Widget>[
											TextFormField(
												controller: _valorController,
												decoration: const InputDecoration(
													labelText: "Valor",
												),
												keyboardType: TextInputType.numberWithOptions(decimal: true),
												autovalidate: true,
											),
											TextFormField(
												controller: _descricaoController,
												decoration: const InputDecoration(
													labelText: "Descrição",
												),
												textCapitalization: TextCapitalization.sentences,
												maxLines: 3,
												maxLength: 500,
												keyboardType: TextInputType.multiline,
												autovalidate: true,
											),
											DateTimeField(
												format: widget.format,
												controller: _dataController,
												onShowPicker: (context, currentValue) async {
													final date = await showDatePicker(
														context: context,
														firstDate: DateTime(1900),
														initialDate: currentValue ?? DateTime.now(),
														lastDate: DateTime(2100),
														builder: (context, child) => Localizations.override(
															context: context,
															locale: Locale('pt', 'BR'),
															child: child,
														),
													);
													if (date != null) {
														final time = await showTimePicker(
															context: context,
															initialTime:
															TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
															builder: (context, child) => Localizations.override(
																context: context,
																locale: Locale('pt', 'BR'),
																child: child,
															),
														);
														return DateTimeField.combine(date, time);
													} else {
														return currentValue;
													}
												},
											),
										],
									),
								),
							],
						),
					),
				),
			),
			actions: <Widget>[
				widget.isEdit ?
				FlatButton(
					child: const Text("CANCELAR"),
					onPressed: () {
						this.resetForm();
					},
				) : null,
				FlatButton(
					child: Text(widget.isEdit ? "ATUALIZAR" : "ADICIONAR"),
					onPressed: () {
						this.updateForm();
					},
				)
			],
		);
	}

	void resetForm() {
		_valorController.updateValue(0);
		_descricaoController.text = "";
		_dataController.text = "";
	}

	void updateForm() {
		var item;
		if (widget.base is Receita) {
			item = widget.base as Receita;
			item.descricao = _descricaoController.text;
			item.valor = _valorController.numberValue;
			item.data = Timestamp.fromMicrosecondsSinceEpoch(
				DateTime.parse(_dataController.text).millisecondsSinceEpoch
			);
		} else {
			item = widget.base as Despesa;
			item.descricao = _descricaoController.text;
			item.valor = _valorController.numberValue;
			item.data = Timestamp.fromMicrosecondsSinceEpoch(
				DateTime.parse(_dataController.text).millisecondsSinceEpoch
			);
		}
		widget.updateInfo(item);
	}
}
