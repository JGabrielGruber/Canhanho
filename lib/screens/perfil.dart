import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('Perfil Screen'),
			),
			body: Center(
				child: RaisedButton(
					child: Text('Launch screen'),
					onPressed: () {
						// Navigate to the second screen when tapped.
					},
				),
			),
		);
	}
}