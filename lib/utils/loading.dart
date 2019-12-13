class LoadingState {
	static bool _loading;

	static bool isLoading() {
		return _loading;
	}

	static bool setLoading(bool loading) {
		return _loading = loading;
	}
}