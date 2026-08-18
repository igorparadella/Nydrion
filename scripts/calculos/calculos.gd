extends Control


var formulas = [
	{
		"nome": "IMC",
		"exprecao": "peso/(altura*altura)",
		"variaveis": {
			"peso": 70.0,
			"altura": 1.75
		}
	},
	
	{
		"nome": "Peso Ideal",
		"exprecao": "22*(altura*altura)",
		"variaveis": {
			"altura": 1.75
		}
	},
	
	{
		"nome": "TMB - Mifflin St Jeor Masculino",
		"exprecao": "(10*peso)+(6.25*altura_cm)-(5*idade)+5",
		"variaveis": {
			"peso": 70.0,
			"altura_cm": 175.0,
			"idade": 25.0
		}
	},
	
	{
		"nome": "TMB - Mifflin St Jeor Feminino",
		"exprecao": "(10*peso)+(6.25*altura_cm)-(5*idade)-161",
		"variaveis": {
			"peso": 60.0,
			"altura_cm": 165.0,
			"idade": 25.0
		}
	},
	
	{
		"nome": "Gasto Energético - Sedentário",
		"exprecao": "tmb*1.2",
		"variaveis": {
			"tmb": 1600.0
		}
	},
	
	{
		"nome": "Gasto Energético - Levemente Ativo",
		"exprecao": "tmb*1.375",
		"variaveis": {
			"tmb": 1600.0
		}
	},
	
	{
		"nome": "Gasto Energético - Moderadamente Ativo",
		"exprecao": "tmb*1.55",
		"variaveis": {
			"tmb": 1600.0
		}
	},
	
	{
		"nome": "Gasto Energético - Muito Ativo",
		"exprecao": "tmb*1.725",
		"variaveis": {
			"tmb": 1600.0
		}
	},
	
	{
		"nome": "Água por Peso",
		"exprecao": "peso*35",
		"variaveis": {
			"peso": 70.0
		}
	},
	
	{
		"nome": "Proteína Diária",
		"exprecao": "peso*proteina",
		"variaveis": {
			"peso": 70.0,
			"proteina": 1.6
		}
	},
	
	{
		"nome": "Carboidratos em Gramas",
		"exprecao": "(calorias*percentual)/4",
		"variaveis": {
			"calorias": 2000.0,
			"percentual": 0.5
		}
	},
	
	{
		"nome": "Gorduras em Gramas",
		"exprecao": "(calorias*percentual)/9",
		"variaveis": {
			"calorias": 2000.0,
			"percentual": 0.3
		}
	},
	
	{
		"nome": "Proteínas em Calorias",
		"exprecao": "proteina*4",
		"variaveis": {
			"proteina": 120.0
		}
	},
	
	{
		"nome": "Carboidratos em Calorias",
		"exprecao": "carboidrato*4",
		"variaveis": {
			"carboidrato": 250.0
		}
	},
	
	{
		"nome": "Gorduras em Calorias",
		"exprecao": "gordura*9",
		"variaveis": {
			"gordura": 67.0
		}
	},
	
	{
		"nome": "Déficit Calórico",
		"exprecao": "gasto-calorias",
		"variaveis": {
			"gasto": 2500.0,
			"calorias": 2000.0
		}
	},
	
	{
		"nome": "Superávit Calórico",
		"exprecao": "calorias-gasto",
		"variaveis": {
			"calorias": 3000.0,
			"gasto": 2500.0
		}
	},
	
	{
		"nome": "Percentual de Proteína",
		"exprecao": "(proteina*4/calorias)*100",
		"variaveis": {
			"proteina": 120.0,
			"calorias": 2000.0
		}
	},
	
	{
		"nome": "Percentual de Carboidratos",
		"exprecao": "(carboidrato*4/calorias)*100",
		"variaveis": {
			"carboidrato": 250.0,
			"calorias": 2000.0
		}
	},
	
	{
		"nome": "Percentual de Gorduras",
		"exprecao": "(gordura*9/calorias)*100",
		"variaveis": {
			"gordura": 67.0,
			"calorias": 2000.0
		}
	},
	
	{
		"nome": "Calorias por Quilograma",
		"exprecao": "calorias/peso",
		"variaveis": {
			"calorias": 2000.0,
			"peso": 70.0
		}
	}
]


@onready var grid_container: GridContainer = $ScrollContainer/GridContainer

@onready var nome_input: LineEdit = $ScrollContainer/GridContainer/Panel/MarginContainer/VBoxContainer/LineEdit

@onready var expressao_input: LineEdit = $ScrollContainer/GridContainer/Panel/MarginContainer/VBoxContainer/LineEdit2


func _ready() -> void:
	if GlobalManager.config.has('formulas'):
		formulas = GlobalManager.config["formulas"]
	else:
		GlobalManager.config["formulas"] = formulas
		GlobalManager.salvar_config()
	
	
	var aq = "res://prefab/calculos/formula.res"
	
	var id = 0
	for i in formulas:
		var v = {
			"formula": i.duplicate(true),
			"id" : i.duplicate(true),
			"alvo" : self,
		}
		

		GlobalManager.adicionar_cena_como_filho(
			aq,
			grid_container,
			v
		)
		
		id += 1
		


func _on_button_pressed() -> void:
	# Verifica se os campos existem
	if nome_input == null:
		print("ERRO: LineEdit do nome não foi encontrado.")
		return

	if expressao_input == null:
		print("ERRO: LineEdit da expressão não foi encontrado.")
		return


	var nome := nome_input.text.strip_edges()
	var exprecao := expressao_input.text.strip_edges()


	if nome.is_empty():
		print("Digite um nome para a fórmula.")
		GlobalManager.notificar("Erro", "Digite um nome para a fórmula.")
		return


	if exprecao.is_empty():
		print("Digite uma expressão.")
		GlobalManager.notificar("Erro", "Digite uma expressão.")
		return


	# Normaliza a expressão
	exprecao = normalizar_expressao(exprecao)


	# Encontra as variáveis
	var variaveis := encontrar_variaveis(exprecao)


	var nova_formula = {
		"nome": nome,
		"exprecao": exprecao,
		"variaveis": variaveis
	}


	# Adiciona à lista
	formulas.append(nova_formula)


	# Cria o componente visual
	var aq = "res://prefab/calculos/formula.res"

	var v = {
		"formula": nova_formula.duplicate(true)
	}


	GlobalManager.adicionar_cena_como_filho(
		aq,
		grid_container,
		v
	)


	# Limpa os campos
	nome_input.text = ""
	expressao_input.text = ""


	#print("Nova fórmula adicionada:")
	#print(nova_formula)
	
	GlobalManager.config["formulas"] = formulas
	GlobalManager.salvar_config()


# ============================================================
# NORMALIZAR EXPRESSÃO
# ============================================================

func normalizar_expressao(expressao: String) -> String:
	var resultado := expressao


	# Multiplicação
	resultado = resultado.replace("×", "*")
	resultado = resultado.replace("·", "*")

	# x usado como operador
	resultado = resultado.replace(" x ", " * ")
	resultado = resultado.replace(" X ", " * ")

	# Divisão
	resultado = resultado.replace("÷", "/")

	# Menos
	resultado = resultado.replace("−", "-")

	# Mais
	resultado = resultado.replace("＋", "+")

	# Potências simples
	resultado = resultado.replace("²", "^2")
	resultado = resultado.replace("³", "^3")

	# Decimal com vírgula
	resultado = converter_decimais(resultado)

	return resultado


# ============================================================
# CONVERTER DECIMAIS
# ============================================================

func converter_decimais(texto: String) -> String:
	var resultado := ""
	var i := 0

	while i < texto.length():

		var caractere := texto[i]

		if caractere == ",":
			var anterior_eh_numero := false
			var proximo_eh_numero := false

			if i > 0:
				anterior_eh_numero = texto[i - 1].is_valid_float()

			if i + 1 < texto.length():
				proximo_eh_numero = texto[i + 1].is_valid_float()

			if anterior_eh_numero and proximo_eh_numero:
				resultado += "."
			else:
				resultado += caractere
		else:
			resultado += caractere

		i += 1

	return resultado


# ============================================================
# ENCONTRAR VARIÁVEIS
# ============================================================

func encontrar_variaveis(expressao: String) -> Dictionary:
	var resultado := {}

	var regex := RegEx.new()

	regex.compile("[a-zA-Z_][a-zA-Z0-9_]*")

	var encontrados = regex.search_all(expressao)


	for encontrado in encontrados:

		var variavel := encontrado.get_string()

		if eh_funcao_matematica(variavel):
			continue

		if variavel in [
			"PI",
			"TAU",
			"E"
		]:
			continue

		if not resultado.has(variavel):
			resultado[variavel] = 0


	return resultado


# ============================================================
# FUNÇÕES MATEMÁTICAS
# ============================================================

func eh_funcao_matematica(nome: String) -> bool:
	return nome in [
		"sin",
		"cos",
		"tan",
		"asin",
		"acos",
		"atan",
		"sqrt",
		"abs",
		"floor",
		"ceil",
		"round",
		"pow",
		"min",
		"max",
		"log",
		"log10",
		"exp"
	]
