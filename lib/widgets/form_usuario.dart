import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:canhanho/repositories/usuario.dart';
import 'package:canhanho/utils/validator_usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class FormUsuario extends StatefulWidget {

	final UserInfo userInfo;
	final Function updateInfo, showTermos;
	final bool isEdit;
	bool termos = false;

	FormUsuario({this.userInfo, this.updateInfo, this.isEdit = false, this.showTermos = null});

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

	File _file;

	@override
	void initState() {
		resetForm();
		super.initState();
	}

	Future _pickPhoto() async {
		await ImagePicker.pickImage(
			source: ImageSource.gallery
		).then((file) {
			setState(() {
				_file = file;
			});
		});
	}

	@override
	Widget build(BuildContext context) {
		return SafeArea(
			child: Column(
				children: <Widget>[
					Form(
						key: _formKey,
						child: Column(
							children: <Widget>[
								GestureDetector(
									child: _file != null ?
										new ClipRRect(
											borderRadius: new BorderRadius.circular(180.0),
											child: Image.file(
												_file,
												width: 120,
												height: 120,
											),
										) : (
										Provider.of<UsuarioModel>(context).usuario != null &&
											Provider.of<UsuarioModel>(context).usuario.photoUrl != null ?
										new ClipRRect(
											borderRadius: new BorderRadius.circular(180.0),
											child: new CachedNetworkImage(
												imageUrl: Provider.of<UsuarioModel>(context, listen: true).usuario.photoUrl,
												placeholder: (context, url) => CircularProgressIndicator(),
												width: 120,
												height: 120,
											),
										) :
										Icon(
											Icons.account_circle,
											color: Colors.grey,
											size: 120,
										)
									),
									onTap: _pickPhoto,
								),
								TextFormField(
									controller: _nomeController,
									validator: textValidator("o seu nome"),
									decoration: const InputDecoration(
										icon: Icon(Icons.person),
										labelText: "Nome",
									),
									textCapitalization: TextCapitalization.words,
									autovalidate: true,
								),
								TextFormField(
									controller: _emailController,
									validator: textValidator("o seu e-mail"),
									decoration: const InputDecoration(
										icon: Icon(Icons.email),
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
										icon: Icon(Icons.security),
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
											icon: Icon(Icons.security),
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
												onChanged: (value) => setState(() => widget.termos = value),
											),
											Text(
												"Aceito os "
											),
											FlatButton(
												padding: EdgeInsets.only(left: 0, right: 8),
												textColor: Colors.blue,
												child: const Text("Termos de Contrato"),
												onPressed: widget.showTermos,
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
		_file = null;
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
				oldPassword,
				_file
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
				hideLoadingDialog();
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
				newPassword,
				_file
			).catchError((error) {
				hideLoadingDialog();
				showDialog(
					context: context,
					builder: (BuildContext context) {
						return AlertDialog(
							title: Text("ERRO"),
							content: Container(
								child: Text(
									error.code
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
