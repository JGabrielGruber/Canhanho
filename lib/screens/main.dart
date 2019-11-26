import 'package:canhanho/screens/despesas.dart';
import 'package:canhanho/screens/receitas.dart';
import 'package:flutter/material.dart';

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
								Icon(Icons.supervised_user_circle),
								Text("Usuário")
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

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.dashboard);
  }
}
