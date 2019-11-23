import 'package:canhanho/repositories/usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
	@override
	_LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

	final _formKey = GlobalKey<FormState>();
	final TextEditingController _emailController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();

	@override
	Widget build(BuildContext context) {
		checkSign();
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
						Form(
							key: _formKey,
							child: Column(
								children: <Widget>[
									TextFormField(
										controller: _emailController,
										decoration: const InputDecoration(
											labelText: "E-mail",
										),
										keyboardType: TextInputType.emailAddress,
										autovalidate: true,
										validator: emailValidator,
									),
									const SizedBox(height: 12.0),
									TextFormField(
										controller: _passwordController,
										decoration: const InputDecoration(
											labelText: "Senha",
										),
										obscureText: true,
										autovalidate: true,
										validator: passwordValidator,
									),
								],
							),
						),
						const SizedBox(height: 24.0),
						RaisedButton(
							child: const Text("ACESSAR"),
							color: Colors.blue,
							textColor: Colors.white,
							onPressed: () {
								if (_formKey.currentState.validate())
									logIn();
							},

						),
						const SizedBox(height: 48.0),
						FlatButton(
							child: const Text("CRIAR CONTA"),
							onPressed: () {
								signIn();
							},
						),
					],
				),
			),
		);
	}

	void logIn() async {
		print(_emailController.text);
		print(_passwordController.text);
		Provider.of<UsuarioModel>(context, listen: false)
			.signIn(
			_emailController.text,
			_passwordController.text
		)
			.then((response) => checkSign())
			.catchError((error) {
				switch (error.code) {
					case "ERROR_USER_NOT_FOUND":
						showDialog(
							context: context,
							builder: (BuildContext context) {
								return AlertDialog(
									title: Text("Não encontrado"),
									content: Container(
										child: Text(
											"E-mail não encontrado, crie uma conta se deseja usá-lo."
										),
									),
									actions: <Widget>[
										FlatButton(
											child: Text('Ok'),
											onPressed: () {
												Navigator.of(context).pop();
											},
										),
									],
								);
							});
						break;
					case "ERROR_WRONG_PASSWORD":
						showDialog(
							context: context,
							builder: (BuildContext context) {
								return AlertDialog(
									title: Text("Inválido"),
									content: Container(
										child: Text(
											"Credênciais inválidas, tente novamente."
										),
									),
									actions: <Widget>[
										FlatButton(
											child: Text('Ok'),
											onPressed: () {
												Navigator.of(context).pop();
											},
										),
									],
								);
							});
						break;
					default:
						showDialog(
							context: context,
							builder: (BuildContext context) {
								return AlertDialog(
									title: Text("Erro"),
									content: Container(
										child: Text(error.code),
									),
									actions: <Widget>[
										FlatButton(
											child: Text('Ok'),
											onPressed: () {
												Navigator.of(context).pop();
											},
										),
									],
								);
							});
				}
			});
		}

		void checkSign() async {
			Provider.of<UsuarioModel>(context, listen: true)
				.isSigned()
				.then((isSigned) {
				if (isSigned) {
					Navigator.of(context).pushReplacementNamed("/main");
				}
			});
		}

		void signIn() {
			Navigator.of(context).pushNamed("/signup");
		}

		String emailValidator(String value) {
			if(value.isEmpty) {
				return "Informe um e-mail";
			}
			return null;
		}

		String passwordValidator(String value) {
			if (value.isEmpty) {
				return "Informe uma senha";
			} else if (value.length < 7) {
				return "A senha precisa conter ao menos 6 dígitos";
			}
			return null;
		}
	}
