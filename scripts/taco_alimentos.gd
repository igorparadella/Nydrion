class_name TacoAlimento
extends Node


const CAMINHO_TACO := "res://data_base/taco_alimentos.json"

var info: Dictionary = {}
var alimentos: Array = []


func _init() -> void:
	carregar()


# ============================================================
# CARREGAR TACO
# ============================================================

func carregar() -> bool:

	if not FileAccess.file_exists(CAMINHO_TACO):
		push_error("Arquivo TACO não encontrado: " + CAMINHO_TACO)
		return false

	var arquivo := FileAccess.open(CAMINHO_TACO, FileAccess.READ)

	if arquivo == null:
		push_error("Não foi possível abrir o arquivo TACO.")
		return false

	var texto := arquivo.get_as_text()
	arquivo.close()

	var json := JSON.new()

	var erro := json.parse(texto)

	if erro != OK:
		push_error(
			"Erro ao ler TACO: "
			+ json.get_error_message()
			+ " | Linha: "
			+ str(json.get_error_line())
		)

		return false

	if typeof(json.data) != TYPE_DICTIONARY:
		push_error("O arquivo TACO não possui um Dictionary válido.")
		return false

	info = json.data
	alimentos = info.get("alimentos", [])

	print("TACO carregada: ", alimentos.size(), " alimentos")

	return true


# ============================================================
# PESQUISAR ALIMENTO
# ============================================================

func pesquisar_alimento(nome: String) -> Dictionary:

	var pesquisa := normalizar_pesquisa(nome)

	if pesquisa.is_empty():
		return {}

	# --------------------------------------------------------
	# 1. TENTA NOME EXATO NORMALIZADO
	# --------------------------------------------------------

	for alimento in alimentos:

		var nome_alimento := normalizar_pesquisa(
			str(alimento.get("nome", ""))
		)

		if nome_alimento == pesquisa:
			return alimento


	# --------------------------------------------------------
	# 2. TENTA CONTÉM
	# --------------------------------------------------------

	for alimento in alimentos:

		var nome_alimento := normalizar_pesquisa(
			str(alimento.get("nome", ""))
		)

		if nome_alimento.contains(pesquisa):
			return alimento


	return {}


# ============================================================
# PESQUISAR VÁRIOS ALIMENTOS
# ============================================================

func pesquisar_alimentos(texto: String) -> Array:

	var resultados: Array = []

	var pesquisa := normalizar_pesquisa(texto)

	if pesquisa.is_empty():
		return resultados

	# --------------------------------------------------------
	# 1. RESULTADOS EXATOS
	# --------------------------------------------------------

	for alimento in alimentos:

		var nome := normalizar_pesquisa(
			str(alimento.get("nome", ""))
		)

		if nome == pesquisa:
			resultados.append(alimento)


	# --------------------------------------------------------
	# 2. RESULTADOS QUE CONTÊM A PESQUISA
	# --------------------------------------------------------

	for alimento in alimentos:

		var nome := normalizar_pesquisa(
			str(alimento.get("nome", ""))
		)

		if nome.contains(pesquisa):

			if not resultados.has(alimento):
				resultados.append(alimento)


	# --------------------------------------------------------
	# 3. PESQUISA POR PALAVRAS
	# --------------------------------------------------------

	var palavras := pesquisa.split(" ", false)

	for alimento in alimentos:

		var nome := normalizar_pesquisa(
			str(alimento.get("nome", ""))
		)

		var encontrou_todas := true

		for palavra in palavras:

			if not nome.contains(palavra):
				encontrou_todas = false
				break

		if encontrou_todas:

			if not resultados.has(alimento):
				resultados.append(alimento)


	return resultados


# ============================================================
# PESQUISAR POR ID
# ============================================================

func pesquisar_por_id(id: int) -> Dictionary:

	for alimento in alimentos:

		if alimento.get("id", -1) == id:
			return alimento

	return {}


# ============================================================
# PESQUISAR POR GRUPO
# ============================================================

func pesquisar_por_grupo(grupo: String) -> Array:

	var resultados: Array = []

	var pesquisa := normalizar_pesquisa(grupo)

	if pesquisa.is_empty():
		return resultados

	for alimento in alimentos:

		var grupo_alimento := normalizar_pesquisa(
			str(alimento.get("grupo", ""))
		)

		if grupo_alimento.contains(pesquisa):
			resultados.append(alimento)

	return resultados


# ============================================================
# NORMALIZAR PESQUISA
# ============================================================

func normalizar_pesquisa(texto: String) -> String:

	texto = texto.to_lower()

	# --------------------------------------------------------
	# REMOVE ACENTOS
	# --------------------------------------------------------

	var acentos := {
		"á": "a",
		"à": "a",
		"ã": "a",
		"â": "a",
		"ä": "a",

		"é": "e",
		"è": "e",
		"ê": "e",
		"ë": "e",

		"í": "i",
		"ì": "i",
		"î": "i",
		"ï": "i",

		"ó": "o",
		"ò": "o",
		"õ": "o",
		"ô": "o",
		"ö": "o",

		"ú": "u",
		"ù": "u",
		"û": "u",
		"ü": "u",

		"ç": "c"
	}

	for caractere in acentos:
		texto = texto.replace(
			caractere,
			acentos[caractere]
		)


	# --------------------------------------------------------
	# REMOVE PONTUAÇÃO
	# --------------------------------------------------------

	var pontuacao := [
		",",
		".",
		";",
		":",
		"(",
		")",
		"[",
		"]",
		"{",
		"}",
		"-",
		"_",
		"/"
	]

	for caractere in pontuacao:
		texto = texto.replace(caractere, " ")


	# --------------------------------------------------------
	# REMOVE PALAVRAS IRRELEVANTES
	# --------------------------------------------------------

	var palavras_ignoradas := [
		"em",
		"de",
		"da",
		"do",
		"das",
		"dos"
	]

	var palavras := texto.split(" ", false)

	var resultado: Array[String] = []

	for palavra in palavras:

		if palavra.is_empty():
			continue

		if palavras_ignoradas.has(palavra):
			continue

		resultado.append(palavra)


	# --------------------------------------------------------
	# RECONSTRÓI O TEXTO
	# --------------------------------------------------------

	return " ".join(resultado).strip_edges()
