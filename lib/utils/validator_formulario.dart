textValidator(String substring) {
	return (String value) {
		if(value.isEmpty) {
			return "Informe ${substring}";
		}
		return null;
	};
}


valueValidator(String substring) {
	return (String value) {
		if(value.isEmpty) {
			return "Informe ${substring}";
		}
		return null;
	};
}