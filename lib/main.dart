import 'package:canhanho/repositories/despesa.dart';
import 'package:canhanho/repositories/receita.dart';
import 'package:canhanho/repositories/usuario.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:provider/provider.dart';
import "routes.dart";
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(
    LoadingProvider(
        child: MultiProvider(
            providers: [
                ChangeNotifierProvider(builder: (context) => UsuarioModel()),
                ChangeNotifierProvider(builder: (context) => ReceitaListModel()),
                ChangeNotifierProvider(builder: (context) => DespesaListModel()),
            ],
            child: MaterialApp(
                title: "Canhanho",
                initialRoute: "/",
                routes: routes,
                localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                    const Locale('pt', 'BR'),
                ],
            ),
        )
    )
);