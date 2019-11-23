textValidator(String substring) {
	return (String value) {
		if(value.isEmpty) {
			return "Informe ${substring}";
		}
		return null;
	};
}


String passwordValidator(String value) {
	if (value.isEmpty) {
		return "Informe uma senha";
	} else if (value.length < 7) {
		return "A senha precisa conter ao menos 6 dígitos";
	}
	return null;
}