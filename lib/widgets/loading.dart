import 'package:canhanho/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class Loading extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
		return Visibility(
			child: Container(
				height: 500,
				child: Column(
					children: <Widget> [
						Expanded(
							child: Align(
								alignment: Alignment.center,
								child: SpinKitPouringHourglass(
									color: Colors.blue,
									size: 50.0,
								),
							),
						)

		]
				)
			),
			visible: Provider.of<LoadingState>(context, listen: true).isLoading(),
		);
	}
}