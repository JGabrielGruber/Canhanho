import 'package:canhanho/repositories/usuario.dart';
import 'package:canhanho/widgets/form_usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PerfilScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('Perfil Screen'),
			),
			body: Center(
				child: FormUsuario(
					isEdit: true,
					userInfo: Provider.of<UsuarioModel>(context).usuario,
					updateInfo: Provider.of<UsuarioModel>(context).updateProfile,
				)
			),
		);
	}
}