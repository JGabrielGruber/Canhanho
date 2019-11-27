import 'package:canhanho/repositories/base.dart';
import 'package:canhanho/repositories/despesa.dart';
import 'package:canhanho/repositories/receita.dart';
import 'package:canhanho/repositories/usuario.dart';
import 'package:canhanho/screens/despesas.dart';
import 'package:canhanho/screens/receitas.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return DefaultTabController(
			length: 3,
			child: Scaffold(
				appBar: AppBar(
					title: GestureDetector(
						onTap: () {
							Navigator.of(context).pushNamed("/main/perfil");
						},
						child: Row(
							crossAxisAlignment: CrossAxisAlignment.center,
							children: <Widget>[
								Provider.of<UsuarioModel>(context).usuario.photoUrl != null ?
								new ClipRRect(
									borderRadius: new BorderRadius.circular(180.0),
									child: Image.network(
										Provider.of<UsuarioModel>(context).usuario.photoUrl,
										width: 40,
										height: 40,
									),
								) :
								Icon(
									Icons.account_circle,
									size: 40,
								),
								Padding(
									padding: EdgeInsets.all(5),
									child: Text(
										Provider.of<UsuarioModel>(context).usuario.displayName,
									),
								),
							],
						),
					),
					bottom: TabBar(
						tabs: [
							Tab(
								text: "Dashboard",
								icon: Icon(Icons.dashboard),
							),
							Tab(
								text: "Receitas",
								icon: Icon(Icons.trending_up),
							),
							Tab(
								text: "Despesas",
								icon: Icon(Icons.trending_down),
							)
						]
					),
				),
				body: TabBarView(
					children: [
						DashboardScreen(),
						ReceitasScreen(),
						DespesasScreen(),
					]
				),
			)
		);
	}
}

class DashboardScreen extends StatelessWidget {
	static List<Receita> _dataReceita = List<Receita>();
	static List<Despesa> _dataDespesa = List<Despesa>();
	static Series<Receita, DateTime> _receitas;
	static Series<Despesa, DateTime> _despesas;

	DashboardScreen();

	@override
	Widget build(BuildContext context) {
		return SingleChildScrollView(
			scrollDirection: prefix0.Axis.vertical,
			child: Container(
					padding: EdgeInsets.all(20),
					child: new SizedBox(
						height: 400,
						child: new TimeSeriesChart(
							_createSeries(context),
							dateTimeFactory: const LocalDateTimeFactory(),
							behaviors: [
								new SeriesLegend()
							],
							animate: false,
							defaultRenderer: LineRendererConfig(includePoints: true),
						),
					)
				),
		);
	}

	/// Create one series with sample hard coded data.
	static List<Series<Base, DateTime>> _createSeries(BuildContext context) {

		Provider.of<ReceitaListModel>(context).get().then((ObserverList<Receita> observerList) {
			if (observerList.length != _dataReceita.length) {
				observerList.forEach((Receita receita) {
					if (_dataReceita.indexWhere((test) => test.uid == receita.uid) < 0) {
						_dataReceita.add(receita);
					}
				});
			}
		});

		Provider.of<DespesaListModel>(context).get().then((ObserverList<Despesa> observerList) {
			if (observerList.length != _dataDespesa.length) {
				observerList.forEach((Despesa despesa) {
					if (_dataDespesa.indexWhere((test) => test.uid == despesa.uid) < 0) {
						_dataDespesa.add(despesa);
					}
				});
			}
		});

		if (_receitas == null) {
			_receitas = new Series<Receita, DateTime>(
				id: 'Receitas',
				colorFn: (_, __) => MaterialPalette.green.shadeDefault,
				domainFn: (Receita receita, _) => receita.data.toDate(),
				measureFn: (Receita receita, _) => receita.valor,
				data: _dataReceita,
			);
		}

		if (_despesas == null) {
			_despesas = new Series<Despesa, DateTime>(
				id: 'Despesas',
				colorFn: (_, __) => MaterialPalette.red.shadeDefault,
				domainFn: (Despesa despesa, _) => despesa.data.toDate(),
				measureFn: (Despesa despesa, _) => despesa.valor,
				data: _dataDespesa,
			);
		}

		return [
			_receitas,
			_despesas,
		];
	}

}