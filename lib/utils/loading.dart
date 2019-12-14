import 'package:flutter/cupertino.dart';

class LoadingState extends ChangeNotifier {
	static bool _loading = false;

	LoadingState();

	bool isLoading() {
		return _loading;
	}

	bool setLoading(bool loading) {
		_loading = loading;
		print(_loading);
		notifyListeners();
		return _loading;
	}
}