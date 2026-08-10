extends Node

# ============================================================
# CONFIGURAÇÃO
# ============================================================

# false = arquivo JSON normal
# true  = arquivo criptografado
const USAR_CRIPTOGRAFIA := false

const CAMINHO_DATA := "user://data.json"

# Senha usada para criptografar o arquivo.
# Troque antes de publicar.
const SENHA_DATA := "NutriPro_2026_Chave"


# ============================================================
# DADOS
# ============================================================

var data: Dictionary = {
}


# ============================================================
# READY
# ============================================================

func _ready() -> void:
	carregar_data()


# ============================================================
# SALVAR DATA
# ============================================================

func salvar_data() -> void:

	var arquivo: FileAccess

	# --------------------------------------------------------
	# Abre o arquivo normalmente ou criptografado
	# --------------------------------------------------------

	if USAR_CRIPTOGRAFIA:
		arquivo = FileAccess.open_encrypted_with_pass(
			CAMINHO_DATA,
			FileAccess.WRITE,
			SENHA_DATA
		)
	else:
		arquivo = FileAccess.open(
			CAMINHO_DATA,
			FileAccess.WRITE
		)

	# --------------------------------------------------------
	# Verifica se conseguiu abrir
	# --------------------------------------------------------

	if arquivo == null:
		push_error("Não foi possível abrir o arquivo para salvar.")
		return

	# --------------------------------------------------------
	# Converte o Dictionary para JSON
	# --------------------------------------------------------

	var texto := JSON.stringify(data)

	# --------------------------------------------------------
	# Salva
	# --------------------------------------------------------

	arquivo.store_string(texto)
	arquivo.close()

	print("Data salva com sucesso!")


# ============================================================
# CARREGAR DATA
# ============================================================

func carregar_data() -> void:

	if not FileAccess.file_exists(CAMINHO_DATA):
		print("Nenhum arquivo de data encontrado.")
		data = {}
		return

	var arquivo: FileAccess

	# --------------------------------------------------------
	# Abre o arquivo normalmente ou descriptografado
	# --------------------------------------------------------

	if USAR_CRIPTOGRAFIA:
		arquivo = FileAccess.open_encrypted_with_pass(
			CAMINHO_DATA,
			FileAccess.READ,
			SENHA_DATA
		)
	else:
		arquivo = FileAccess.open(
			CAMINHO_DATA,
			FileAccess.READ
		)

	# --------------------------------------------------------
	# Verifica se conseguiu abrir
	# --------------------------------------------------------

	if arquivo == null:
		push_error("Não foi possível abrir o arquivo de data.")
		data = {}
		return

	# --------------------------------------------------------
	# Lê o JSON
	# --------------------------------------------------------

	var texto := arquivo.get_as_text()

	arquivo.close()

	# --------------------------------------------------------
	# Converte JSON para Dictionary
	# --------------------------------------------------------

	var resultado = JSON.parse_string(texto)

	if resultado is Dictionary:
		data = resultado

		print("Data carregada com sucesso!")
	else:
		push_error("O arquivo não contém um Dictionary válido.")
		data = {}


# ============================================================
# APAGAR DATA
# ============================================================

func apagar_data() -> void:

	if FileAccess.file_exists(CAMINHO_DATA):

		var caminho_absoluto := ProjectSettings.globalize_path(
			CAMINHO_DATA
		)

		DirAccess.remove_absolute(caminho_absoluto)

	data = {}

	print("Data apagada!")


# ============================================================
# EXEMPLO
# ============================================================

func exemplo() -> void:

	data["nome"] = "Igor"
	data["idade"] = 20
	data["peso"] = 75.5
	data["altura"] = 1.80

	salvar_data()
