import 'package:canhanho/utils/validator_usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FormUsuario extends StatefulWidget {

	final UserInfo userInfo;
	final Function updateInfo;
	final bool isEdit;

	FormUsuario({this.userInfo, this.updateInfo, this.isEdit = false});

	@override
	_FormUsuarioState createState() => _FormUsuarioState();
}

class _FormUsuarioState extends State<FormUsuario> {

	final _formKey = GlobalKey<FormState>();
	var _passwordEdited = false;

	final TextEditingController _nomeController = TextEditingController(),
		_emailController = TextEditingController(),
		_newPasswordController = TextEditingController(),
		_oldPasswordController = TextEditingController();

	@override
	void initState() {
		resetForm();
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			child: Column(
				children: <Widget>[
					Form(
						key: _formKey,
						child: Column(
							children: <Widget>[
								TextFormField(
									controller: _nomeController,
									validator: textValidator("o seu nome"),
									decoration: const InputDecoration(
										labelText: "Nome",
									),
									textCapitalization: TextCapitalization.words,
									autovalidate: true,
								),
								TextFormField(
									controller: _emailController,
									validator: textValidator("o seu e-mail"),
									decoration: const InputDecoration(
										labelText: "E-mail",
									),
									keyboardType: TextInputType.emailAddress
								),
								TextFormField(
									controller: _newPasswordController,
									validator: _passwordEdited ? passwordValidator : null,
									decoration: const InputDecoration(
										labelText: "Senha",
									),
									obscureText: true,
									onChanged: (arg) {
										if (widget.isEdit)
											setState(() {
											  _passwordEdited = true;
											});
									},
								),
								Visibility(
									child: TextFormField(
										controller: _oldPasswordController,
										validator: passwordValidator,
										decoration: const InputDecoration(
											labelText: "Antiga senha",
										),
										obscureText: true,

									),
									visible: _passwordEdited,
								),
							],
						),
					),
					ButtonBar(
						children: <Widget>[
							FlatButton(
								child: const Text("CANCELAR"),
								onPressed: resetForm,
							),
							RaisedButton(
								child: const Text("ATUALIZAR"),
								color: Colors.blue,
								textColor: Colors.white,
								onPressed: () {
									if (_formKey.currentState.validate()) {
										update();
									}
								},
							)
						],
					)
				],
			),
		);
	}

	void resetForm() {
		_nomeController.text = widget.userInfo.displayName;
		_emailController.text = widget.userInfo.email;
		_newPasswordController.text = "";
		_oldPasswordController.text = "";
		setState(() {
		  _passwordEdited = false;
		});
	}

	void update() {
		UserUpdateInfo user = UserUpdateInfo();
		user.displayName = _nomeController.text;
		String email = _emailController.text != widget.userInfo.email
			? _emailController.text : null;
		String newPassword = _newPasswordController.text.isEmpty
			? null : _newPasswordController.text;
		String oldPassword = _oldPasswordController.text.isEmpty
			? null : _oldPasswordController.text;
		widget.updateInfo(
			user,
			email,
			newPassword,
			oldPassword
		).then((arg) {
			resetForm();
			showDialog(
				context: context,
				builder: (BuildContext context) {
					return AlertDialog(
						title: Text("SUCESSO"),
						content: Container(
							child: Text(
								"Seus dados foram atualizados."
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
		}).catchError((error) {
			switch (error.code) {
				case "ERROR_WRONG_PASSWORD":
					showDialog(
						context: context,
						builder: (BuildContext context) {
							return AlertDialog(
								title: Text("SENHA INCORRETA"),
								content: Container(
									child: Text(
										"A antiga senha informada está incorreta."
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
}
