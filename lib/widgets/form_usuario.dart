import 'package:canhanho/utils/validator_usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FormUsuario extends StatefulWidget {

	final UserInfo userInfo;
	final Function updateInfo;
	final bool isEdit;
	bool termos = false;

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
									keyboardType: TextInputType.emailAddress,
									autovalidate: !widget.isEdit,
								),
								TextFormField(
									controller: _newPasswordController,
									validator: widget.isEdit ?
										(_passwordEdited ? passwordValidator : null) :
										passwordValidator,
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
									autovalidate: !widget.isEdit,
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
								Visibility(
									child: Row(
										mainAxisAlignment: MainAxisAlignment.end,
										children: <Widget>[
											Switch(
												value: widget.termos,
												onChanged: (value) {
													widget.termos = value;
												},
											),
											Text(
												"Aceito os "
											),
											FlatButton(
												padding: EdgeInsets.only(left: 0, right: 8),
												textColor: Colors.blue,
												child: const Text("Termos de Contrato"),
												onPressed: resetForm,
											)
										],
									),
									visible: !widget.isEdit,
								)
							],
						),
					),
					ButtonBar(
						children: <Widget>[
							widget.isEdit ?
							FlatButton(
								child: const Text("CANCELAR"),
								onPressed: resetForm,
							) : null,
							RaisedButton(
								child: Text(widget.isEdit ? "ATUALIZAR" : "CADASTRAR"),
								color: Colors.blue,
								textColor: Colors.white,
								onPressed: () {
									print((widget.isEdit ? true : widget.termos));
									if (_formKey.currentState.validate()
										&& (widget.isEdit ? true : widget.termos)) {
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
		if (widget.isEdit) {
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
				print(error);
				if (error.code != null) {
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
				} else {
					print(error);
				}
			});
		} else {
			widget.updateInfo(
				user.displayName,
				email,
				newPassword
			).catchError((error) {
				showDialog(
					context: context,
					builder: (BuildContext context) {
						return AlertDialog(
							title: Text("ERRO"),
							content: Container(
								child: Text(
									error
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
			});
		}

	}
}
