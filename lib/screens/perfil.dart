import 'package:canhanho/repositories/usuario.dart';
import 'package:canhanho/widgets/form_usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canhanho/widgets/loading.dart';
import 'package:canhanho/utils/loading.dart';

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

  Future<void> _showConfirmacao() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmacao"),
          content: SingleChildScrollView(
            child: Text('Deseja realmente sair?'),
          ),
          actions: <Widget>[
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancelar"),
                ),
                FlatButton(
                    onPressed: _signOut,
                    child: Text("Sim")
                )
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingState.isLoading() ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              FormUsuario(
                isEdit: true,
                userInfo: Provider.of<UsuarioModel>(context).usuario,
                updateInfo: Provider.of<UsuarioModel>(context).updateProfile,

              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                      onPressed: _showConfirmacao,
                      child: Text(
                        'SAIR',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      )),
                ),
              ),

            ],
          )

      ),
    );
  }

}