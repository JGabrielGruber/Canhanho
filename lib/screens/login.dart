import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
	final TextEditingController _usernameController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: SafeArea(
				child: ListView(
					padding: const EdgeInsets.symmetric(horizontal: 24.0),
					children: <Widget>[
						const SizedBox(height: 80.0),
						Column(
							children: <Widget>[
								Image.asset(''),
								const SizedBox(height: 30.0),
								Text(
									"Canhanho",
									style: Theme.of(context).textTheme.headline,
								),
							],
						),
						const SizedBox(height: 100.0),
						TextField(
							controller: _usernameController,
							decoration: const InputDecoration(
								labelText: "E-mail",
							),
						),
						const SizedBox(height: 12.0),
						TextField(
							controller: _passwordController,
							decoration: const InputDecoration(
								labelText: "Senha",
							),
						),
						const SizedBox(height: 24.0),
						RaisedButton(
							child: const Text("ACESSAR"),
							color: Colors.blue,
							textColor: Colors.white,
							onPressed: () {
								Navigator.pop(context);
							},
						),
						const SizedBox(height: 48.0),
						FlatButton(
							child: const Text("CRIAR CONTA"),
							onPressed: () {
								_usernameController.clear();
								_passwordController.clear();
							},
						),
					],
				),
			),
		);
	}
}
