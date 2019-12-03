import 'package:canhanho/repositories/usuario.dart';
import 'package:canhanho/widgets/form_usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class SignupScreen extends StatelessWidget {

	@override
	Widget build(BuildContext context) {

		Future<String> loadAsset() async {
			return await rootBundle.loadString('assets/LICENSE');
		}

		Future<void> _showTermos() async {
			var text = await loadAsset();
			return showDialog<void>(
				context: context,
				barrierDismissible: false,
				builder: (BuildContext context) {
					return AlertDialog(
						title: Text("Termos de Contrato"),
						content: SingleChildScrollView(
							child: Text(text),
						),
						actions: <Widget>[
							ButtonBar(
								children: <Widget>[
									FlatButton(
										onPressed: () {
											Navigator.of(context).pop();
										},
										child: Text("OK")
									)
								],
							)
						],
					);
				},
			);
		}

		return Scaffold(
			appBar: AppBar(
				title: Text('Cadastrar conta'),
			),
			body: SingleChildScrollView(
				child: Container(
					padding: EdgeInsets.all(24.0),
					child: FormUsuario(
						isEdit: false,
						userInfo: new User(),
						updateInfo: Provider.of<UsuarioModel>(context).signUp,
						showTermos: _showTermos,
					),
				)
			),
		);
	}
}