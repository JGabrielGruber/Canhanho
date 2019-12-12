import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

	int _selectedIndex = 0;
	static List<Widget> _widgetsOptions = <Widget>[
		DashboardScreen(),
		ReceitasScreen(),
		DespesasScreen(),
	];

	void _onItemTapped(int index) {
		setState(() {
			_selectedIndex = index;
		});
	}

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
									child: CachedNetworkImage(
										imageUrl: Provider.of<UsuarioModel>(context, listen: true).usuario.photoUrl,
										placeholder: (context, url) => CircularProgressIndicator(),
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
				),
				body: _widgetsOptions.elementAt(_selectedIndex),
				bottomNavigationBar: BottomNavigationBar(
					items: const <BottomNavigationBarItem> [
						BottomNavigationBarItem(
							title: Text("Dashboard"),
							icon: Icon(Icons.dashboard),
						),
						BottomNavigationBarItem(
							title: Text("Receitas"),
							icon: Icon(Icons.trending_up),
						),
						BottomNavigationBarItem(
							title: Text("Despesas"),
							icon: Icon(Icons.trending_down),
						)
					],
					currentIndex: _selectedIndex,
					selectedItemColor: Colors.white,
					backgroundColor: Colors.blue,
					unselectedItemColor: Colors.white70,
					onTap: _onItemTapped,
				),
			)
		);
	}
}

class DashboardScreen extends StatelessWidget {
	static List<Receita> _dataReceita = List<Receita>();
	static List<Despesa> _dataDespesa = List<Despesa>();
	static List<Base> _total = List<Base>();
	static Series<Receita, DateTime> _receitas;
	static Series<Despesa, DateTime> _despesas;
	static Series<Base, DateTime> _totais;
	static bool created = false;
	static dynamic valor = 0;
	final formatCurrency = new NumberFormat.simpleCurrency(locale: 'pt-BR');

	DashboardScreen();

	@override
	Widget build(BuildContext context) {
		return SingleChildScrollView(
			scrollDirection: prefix0.Axis.vertical,
			child: Container(
					padding: EdgeInsets.all(20),
					child: Column(
						children: <Widget>[
							Row(
								children: <Widget>[
									Text("Total atual: ", style: TextStyle(
										fontSize: 20,
										fontWeight: FontWeight.bold
									)),
									Text('${formatCurrency.format(valor)}', style: TextStyle(
										fontSize: 20
									))
								],
							),
							Padding(padding: EdgeInsets.all(5)),
							new SizedBox(
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
							),
						],
					),
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

		_total = _createTotais(_dataReceita, _dataDespesa);

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

		_totais = new Series<Base, DateTime>(
			id: 'Totais',
			colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
			domainFn: (item, _) {
				var i;
				if (item is Receita)
					i = item as Receita;
				else
					i = item as Despesa;
				return i.data.toDate();
			},
			measureFn: (item, _) {
				var i;
				if (item is Receita)
					i = item as Receita;
				else
					i = item as Despesa;
				return i.valor;
			},
			data: _total
		);

		return [
			_receitas,
			_despesas,
			_totais
		];
	}

	static List<Base> _createTotais(List<Receita> receita, List<Despesa> despesa) {
		List<Base> total = List<Base>();
		receita.forEach((item) {
			total.add(new Receita(
				uid: item.uid,
				valor: item.valor,
				data: item.data,
				descricao: item.descricao
			));
		});
		despesa.forEach((item) {
			total.add(new Despesa(
				uid: item.uid,
				valor: item.valor,
				data: item.data,
				descricao: item.descricao
			));
		});
		total.sort((a, b) {
			var i, y;
			if (a is Receita)
				i = a as Receita;
			else
				i = a as Despesa;
			if (b is Receita)
				y = b as Receita;
			else
				y = b as Despesa;
			return i.data.compareTo(y.data);
		});
		for(int index = 0; index < total.length; index++) {
			var item = total.elementAt(index);
			if (item is Receita) {
				if (index != 0) {
					var m = total.elementAt(index - 1), a;
					if (m is Despesa)
						a = m as Despesa;
					else
						a = m as Receita;
					var r = item as Receita;
					r.valor = a.valor + r.valor;
				}
			} else {
				if (index != 0) {
					var m = total.elementAt(index - 1), a;
					if (m is Despesa)
						a = m as Despesa;
					else
						a = m as Receita;
					var d = item as Despesa;
					d.valor = a.valor - d.valor;
				} else {
					var d = item as Despesa;
					d.valor = 0 - d.valor;
				}
			}
		}
		if (total.length > 0) {
			var el = total.elementAt(total.length - 1);
			var val;
			if (el is Receita)
				val = el as Receita;
			else
				val = el as Despesa;
			valor = val.valor;
		} else {
			valor = 0.0;
		}

		return total;
	}

}