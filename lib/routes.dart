import 'package:canhanho/screens/despesas.dart';
import 'package:canhanho/screens/login.dart';
import 'package:canhanho/screens/main.dart';
import 'package:canhanho/screens/perfil.dart';
import 'package:canhanho/screens/receitas.dart';
import 'package:canhanho/screens/signup.dart';
import 'package:flutter/material.dart';

var routes = {
	"/": (BuildContext context) => LoginScreen(),
	"/signup": (BuildContext context) => SignupScreen(),
	"/main": (BuildContext context) => MainScreen(),
	"/main/despesas": (BuildContext context) => DespesasScreen(),
	"/main/receitas": (BuildContext context) => ReceitasScreen(),
	"/main/perfil": (BuildContext context) => PerfilScreen(),
};