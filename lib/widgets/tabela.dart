import 'dart:core';
import 'package:canhanho/repositories/base.dart';
import 'package:canhanho/repositories/despesa.dart';
import 'package:canhanho/repositories/receita.dart';
import 'package:canhanho/widgets/custom_paginated_data_table.dart';
import 'package:flutter/material.dart';

class TableBase extends StatefulWidget {

	final List<DataColumn> columns = [
		new DataColumn(label: Text("Valor")),
		new DataColumn(label: Text("Descrição")),
		new DataColumn(label: Text("Data"))
	];
	BaseDataSource source;
	Function onSelected;

	TableBase({List<Base> source, this.onSelected}) {
		this.source = BaseDataSource(list: source, onSelected: this.onSelected);
	}

	@override
	_TableBaseState createState() => _TableBaseState();
}

class _TableBaseState extends State<TableBase> {

	@override
	void initState() {
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			child: CustomPaginatedDataTable(
				columns: widget.columns,
				source: widget.source,
				dataRowHeight: 50,
				columnSpacing: 20,
			),
		);
	}

}

class BaseDataSource extends DataTableSource {

	final List<Base> list;
	int _selectedCount = 0;
	Function onSelected;

	BaseDataSource({this.list, this.onSelected});

	@override
	DataRow getRow(int index) {
		assert(index >= 0);
		if (index >= list.length)
			return null;
		final Base base = list[index];
		var item;
		if (base is Receita)
			item = base as Receita;
		else
			item = base as Despesa;
		return DataRow.byIndex(
			index: index,
			cells: <DataCell> [
				DataCell(Text("${item.valor.toString()}"), onTap: () {this.onSelected(base);}),
				DataCell(Text("${item.descricao}"), onTap: () {this.onSelected(base);}),
				DataCell(Text("${item.data.toDate().toString()}"), onTap: () {this.onSelected(base);}),
			]
		);
	}

	@override
	int get rowCount => list.length;

	@override
	bool get isRowCountApproximate => false;

	@override
	int get selectedRowCount => _selectedCount;

}