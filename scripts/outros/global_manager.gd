extends Node



var checar_atualizacao := false
const USAR_CRIPTOGRAFIA = false

var atalhos := {}

var info = {}

var caminho = ""

var pacientes = {}
var paciente_aberto = {}

var config = {}

var cores := {
	"branco": Color(0xffffffff),
	"verde_claro": Color(0xe1ffdbff),
	"verde_escuro": Color(0x72b879ff),
}


func _ready() -> void:
	pass

func salvar_paciente_aberto():
	if paciente_aberto.has("dados_pessoais") and paciente_aberto["dados_pessoais"].has("nome"):
		var arquivo = paciente_aberto["arquivo"]
		var c = str(caminho,arquivo)
		salvar(paciente_aberto, c)
		
func salvar(data, caminho_save):
	var s : Save_manager = Save_manager.new()
	s.data = data
	s.CAMINHO_DATA = caminho_save
	s.SENHA_DATA = info["senha"]
	s.USAR_CRIPTOGRAFIA = USAR_CRIPTOGRAFIA
	
	s.salvar_data()

func carregar(caminho_save) -> Dictionary:
	var s : Save_manager = Save_manager.new()
	s.CAMINHO_DATA = caminho_save
	s.SENHA_DATA = info["senha"]
	s.USAR_CRIPTOGRAFIA = USAR_CRIPTOGRAFIA
	return s.carregar_data()

func apagar(caminho_save):
	var s : Save_manager = Save_manager.new()
	s.CAMINHO_DATA = caminho_save
	s.apagar_data()


#
#
	## ========================================================
	## TESTE
	## ========================================================
#
	#var alimento := data_taco.pesquisar_alimento(
		#"Fruta-pão, crua"
	#)
#
	#if not alimento.is_empty():
#
		#print("================================")
		#print("ALIMENTO ENCONTRADO")
		#print("================================")
#
		#print("id: ", alimento["id"])
		#print("Nome: ", alimento["nome"])
		#print("Calorias: ", alimento["energia_kcal"], " kcal")
		#print("Proteína: ", alimento["proteina_g"], " g")
		#print("Carboidratos: ", alimento["carboidrato_g"], " g")
		#print("Gorduras: ", alimento["lipideos_g"], " g")
		#print("Fibra: ", alimento["fibra_alimentar_g"], " g")
#
	#else:
#
		#printerr(
			#"Alimento não encontrado: ",
			#"Arroz, integral, cozido"
		#)


func abrir_tela(nome: String):
	atalhos["main"].abrir_tela(nome)

func adicionar_cena_como_filho(
		caminho_cena: String,
		pai: Node,
		variaveis: Dictionary = {}
	) -> Node:
	if pai == null:
		push_error("O nó pai não foi informado.")
		return null

	if not ResourceLoader.exists(caminho_cena):
		push_error("A cena não existe: " + caminho_cena)
		return null

	var cena := load(caminho_cena) as PackedScene

	if cena == null:
		push_error("Não foi possível carregar a cena: " + caminho_cena)
		return null

	# Cria a instância da cena
	var filho := cena.instantiate()

	# Define as variáveis do filho
	for nome_var in variaveis:
		if nome_var in filho:
			filho.set(nome_var, variaveis[nome_var])
		else:
			push_warning(
				"A variável '%s' não existe na cena '%s'."
				% [nome_var, caminho_cena]
			)

	# Adiciona ao pai
	pai.add_child(filho)

	return filho


func array_para_float(array_original: Array) -> Array[float]:
	var resultado: Array[float] = []

	for valor in array_original:
		resultado.append(float(valor))

	return resultado


func array_para_string(array_original: Array) -> Array[String]:
	var resultado: Array[String] = []

	for valor in array_original:
		resultado.append(str(valor))

	return resultado

func normalizar_texto(texto: String) -> String:
	var resultado := texto.to_lower()

	resultado = resultado.replace("á", "a")
	resultado = resultado.replace("à", "a")
	resultado = resultado.replace("ã", "a")
	resultado = resultado.replace("â", "a")
	resultado = resultado.replace("ä", "a")

	resultado = resultado.replace("é", "e")
	resultado = resultado.replace("è", "e")
	resultado = resultado.replace("ê", "e")
	resultado = resultado.replace("ë", "e")

	resultado = resultado.replace("í", "i")
	resultado = resultado.replace("ì", "i")
	resultado = resultado.replace("î", "i")
	resultado = resultado.replace("ï", "i")

	resultado = resultado.replace("ó", "o")
	resultado = resultado.replace("ò", "o")
	resultado = resultado.replace("õ", "o")
	resultado = resultado.replace("ô", "o")
	resultado = resultado.replace("ö", "o")

	resultado = resultado.replace("ú", "u")
	resultado = resultado.replace("ù", "u")
	resultado = resultado.replace("û", "u")
	resultado = resultado.replace("ü", "u")

	resultado = resultado.replace("ç", "c")

	return resultado


func criar_config():
	var c = {
		"id_livre" : 1,
		"agenda" : {}
	}
	print(str(caminho,"config.json"))
	salvar(c,str(caminho,"config.json"))

func salvar_config():
	salvar(config,str(caminho,"config.json"))

func notificar(titulo : String, msg : String):
	var i = {
		"titulo" : titulo,
		"msg" : msg,
	}
	
	adicionar_cena_como_filho("res://prefab/interface/popup.res", atalhos["notificar"], i)
