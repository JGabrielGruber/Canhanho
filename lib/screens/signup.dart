import 'package:canhanho/repositories/usuario.dart';
import 'package:canhanho/widgets/form_usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('Cadastrar conta'),
			),
			body: Container(
				padding: EdgeInsets.all(24.0),
				child: FormUsuario(
					isEdit: false,
					userInfo: new User(),
					updateInfo: Provider.of<UsuarioModel>(context).signUp,
				)
			),
		);
	}
}