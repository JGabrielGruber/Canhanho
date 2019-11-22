import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('Signup Screen'),
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