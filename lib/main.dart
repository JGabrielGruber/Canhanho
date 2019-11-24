import 'package:canhanho/repositories/receita.dart';
import 'package:canhanho/repositories/usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "routes.dart";

void main() => runApp(
    MultiProvider(
        providers: [
            ChangeNotifierProvider(builder: (context) => UsuarioModel()),
            ChangeNotifierProvider(builder: (context) => ReceitaListModel()),
        ],
        child: MaterialApp(
            title: "Canhanho",
            initialRoute: "/",
            routes: routes
        ),
    )
);