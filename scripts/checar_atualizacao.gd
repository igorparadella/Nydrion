extends HTTPRequest


# ============================================================
# CONFIGURAÇÃO
# ============================================================

const VERSAO_ATUAL := "0.0.0"

const VERSION_URL := "https://raw.githubusercontent.com/igorparadella/nutri/main/version.json"


# ============================================================
# INICIALIZAÇÃO
# ============================================================

func _ready() -> void:
	request_completed.connect(_on_request_completed)

	verificar_atualizacao()


# ============================================================
# VERIFICAR ATUALIZAÇÃO
# ============================================================

func verificar_atualizacao() -> void:
	print("Verificando atualização...")

	var erro := request(VERSION_URL)

	if erro != OK:
		print("Erro ao iniciar requisição: ", erro)


# ============================================================
# RESPOSTA DO GITHUB
# ============================================================

func _on_request_completed(
	result: int,
	response_code: int,
	headers: PackedStringArray,
	body: PackedByteArray
) -> void:

	# --------------------------------------------------------
	# Erro de conexão
	# --------------------------------------------------------

	if result != HTTPRequest.RESULT_SUCCESS:
		print("Erro na conexão com o servidor.")
		print("Código do erro: ", result)
		return


	# --------------------------------------------------------
	# Código HTTP
	# --------------------------------------------------------

	if response_code != 200:
		print("GitHub retornou código HTTP: ", response_code)
		return


	# --------------------------------------------------------
	# Converter resposta
	# --------------------------------------------------------

	var texto := body.get_string_from_utf8()

	print("Resposta recebida:")
	print(texto)


	# --------------------------------------------------------
	# Interpretar JSON
	# --------------------------------------------------------

	var json := JSON.new()

	var erro := json.parse(texto)

	if erro != OK:
		print("Erro ao interpretar version.json")
		print(json.get_error_message())
		return


	var dados = json.data


	# --------------------------------------------------------
	# Verificar estrutura
	# --------------------------------------------------------

	if typeof(dados) != TYPE_DICTIONARY:
		print("version.json inválido.")
		return


	if not dados.has("version"):
		print("version.json não possui versão.")
		return


	# --------------------------------------------------------
	# Pegar versão
	# --------------------------------------------------------

	var versao_remota: String = str(dados["version"])

	print("--------------------------------")
	print("Versão instalada: ", VERSAO_ATUAL)
	print("Versão disponível: ", versao_remota)
	print("--------------------------------")


	# --------------------------------------------------------
	# Comparar versões
	# --------------------------------------------------------

	if existe_atualizacao(VERSAO_ATUAL, versao_remota):

		print("🚀 NOVA ATUALIZAÇÃO DISPONÍVEL!")

		if dados.has("url"):
			print("Download: ", dados["url"])

	else:

		print("✅ O projeto está atualizado.")


# ============================================================
# COMPARAR VERSÕES
# ============================================================

func existe_atualizacao(
	versao_instalada: String,
	versao_remota: String
) -> bool:

	var atual := versao_instalada.split(".")
	var remota := versao_remota.split(".")


	# Garantir que temos 3 partes
	while atual.size() < 3:
		atual.append("0")

	while remota.size() < 3:
		remota.append("0")


	# Comparar:
	# MAJOR.MINOR.PATCH

	for i in range(3):

		var numero_atual := int(atual[i])
		var numero_remoto := int(remota[i])


		# A versão remota é maior
		if numero_remoto > numero_atual:
			return true


		# A versão instalada é maior
		if numero_remoto < numero_atual:
			return false


	# São exatamente iguais
	return false
