import 'package:canhanho/repositories/usuario.dart';
import 'package:canhanho/widgets/form_usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PerfilScreen extends StatefulWidget {
	@override
	_PerfilScreenState createState() => _PerfilScreenState();

}

class _PerfilScreenState extends State<PerfilScreen> {

	void _signOut() async {
		try{
			Provider.of<UsuarioModel>(context).signOut();
			Navigator.of(context).pushNamed("/");
		}catch(e){
	print(e);
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('Perfil Screen'),
				actions: <Widget>[
					new FlatButton(onPressed: _signOut, child: new Text('Sair'))
				],
			),
			body: Center(
				child: FormUsuario(
					isEdit: true,
					userInfo: Provider.of<UsuarioModel>(context).usuario,
					updateInfo: Provider.of<UsuarioModel>(context).updateProfile,

				),

			),
		);
	}

}