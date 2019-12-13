import 'package:canhanho/repositories/usuario.dart';
import 'package:canhanho/utils/validator_usuario.dart';
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
						const SizedBox(height: 50.0),
						Column(
							children: <Widget>[
								Image(
									image: AssetImage("assets/canhanho.png"),
									height: 225,
								),
							],
						),
						const SizedBox(height: 10.0),
						Form(
							key: _formKey,
							child: Column(
								children: <Widget>[
									TextFormField(
										controller: _emailController,
										decoration: const InputDecoration(
											icon: Icon(Icons.email),
											labelText: "E-mail",
										),
										keyboardType: TextInputType.emailAddress,
										autovalidate: true,
										validator: textValidator("o e-mail"),
									),
									const SizedBox(height: 12.0),
									TextFormField(
										controller: _passwordController,
										decoration: const InputDecoration(
											icon: Icon(Icons.security),
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
					Navigator.of(context).pushNamedAndRemoveUntil("/main", (Route<dynamic> route) => false);
				}
			});
		}

		void signIn() {
			Navigator.of(context).pushNamed("/signup");
		}
	}
