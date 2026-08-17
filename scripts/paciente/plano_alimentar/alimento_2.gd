extends HBoxContainer

@onready var nome: Label = $Label
@onready var gramas: TextEdit = $HBoxContainer/TextEdit

var valor_gramas: float = 100.0

var data = {}
var pai = null
var tipo = null


func _ready() -> void:
	if data.is_empty():
		queue_free()
		return

	nome.text = data["alimento_data"]["nome"]

	valor_gramas = float(data["gramas"])
	gramas.text = str(valor_gramas)



func atualizar_gramas() -> void:
	# Atualiza o valor local
	data["gramas"] = valor_gramas

	# Pega a lista correta da refeição
	var lista = GlobalManager.paciente_aberto["plano_alimentar"]["refeicoes"][str(pai)][tipo]

	# Procura exatamente o alimento que pertence a este componente
	for item in lista:
		if item["alimento_data"]["id"] == data["alimento_data"]["id"]:
			item["gramas"] = valor_gramas
			break

	# Salva no arquivo/persistência
	GlobalManager.salvar_paciente_aberto()


func _on_texture_button_pressed() -> void:
	var lista = GlobalManager.paciente_aberto["plano_alimentar"]["refeicoes"][str(pai)][tipo]

	for item in lista:
		if item["alimento_data"]["id"] == data["alimento_data"]["id"]:
			lista.erase(item)
			GlobalManager.salvar_paciente_aberto()
			queue_free()
			return


func _on_text_edit_text_changed() -> void:
	var texto := gramas.text.replace(",", ".")

	if texto.is_valid_float():
		valor_gramas = texto.to_float()
		atualizar_gramas()


func _on_btn_mais_pressed() -> void:
	valor_gramas += 10.0

	gramas.text = str(valor_gramas)

	atualizar_gramas()


func _on_btn_menos_pressed() -> void:
	valor_gramas -= 10.0

	if valor_gramas < 10.0:
		valor_gramas = 10.0

	gramas.text = str(valor_gramas)

	atualizar_gramas()
