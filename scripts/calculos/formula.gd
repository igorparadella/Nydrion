extends Panel

@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
var alvo
var id
var formula = {
	
}


func _ready() -> void:
	if formula.is_empty():
		queue_free()
		return
	
	$MarginContainer/VBoxContainer/Label.text = formula["nome"]
	$MarginContainer/VBoxContainer/Label2.text = formula["exprecao"]
	var aq = "res://prefab/calculos/variavel.res"
	
	for i in formula["variaveis"]:
		var v = {
			"variavel": i,
			"destino": self
		}
		
		GlobalManager.adicionar_cena_como_filho(
			aq,
			v_box_container,
			v
		)
	

func calcular_formula():
	var expressao: String = formula["exprecao"]
	var variaveis: Dictionary = formula["variaveis"]

	# Substitui todas as variáveis
	for variavel in variaveis:
		expressao = substituir(
			expressao,
			str(variavel),
			str(variaveis[variavel])
		)

	#print("Expressão: ", expressao)

	# Calcula a expressão
	var resultado = calcular(expressao)
	
	return resultado


func substituir(
	texto: String,
	alvo: String,
	substituicao: String
) -> String:
	return texto.replace(alvo, substituicao)


func calcular(expressao: String):
	var expression := Expression.new()

	var erro := expression.parse(expressao)

	if erro != OK:
		print("Erro na expressão: ", expressao)
		print("Código do erro: ", erro)
		return null

	return expression.execute()


func formatar_numero(valor) -> String:
	if valor == null:
		return ""
	
	var numero := float(valor)
	
	# Se for um número inteiro, remove o .0
	if numero == floor(numero):
		return str(int(numero))
	
	# Se tiver casas decimais, troca . por ,
	return str(numero).replace(".", ",")


func _on_button_pressed() -> void:
	var resultado = calcular_formula()
	
	$MarginContainer/VBoxContainer/HBoxContainer/Label2.text = formatar_numero(resultado)


func _on_texture_button_pressed() -> void:
	GlobalManager.config["formulas"].erase(id)
	GlobalManager.salvar_config()
	GlobalManager.abrir_tela("calculos")
	
