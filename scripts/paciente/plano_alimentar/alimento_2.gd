extends HBoxContainer
@onready var nome: Label = $Label
@onready var gramas: TextEdit = $HBoxContainer/TextEdit

var valor_gramas: float = 100.0

var data = {
	
}
var pai = null
var tipo = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if data.is_empty():
		queue_free()
		return
	
	nome.text = data['alimento_data']["nome"]
	gramas.text = str(data['gramas'])
	valor_gramas = float(data['gramas'])
	


func _on_texture_button_pressed() -> void:
	for i in GlobalManager.paciente_aberto["plano_alimentar"]["refeicoes"][str(pai)][tipo]:
		if i["nome"] == data['alimento_data']["nome"]:
			GlobalManager.paciente_aberto["plano_alimentar"]["refeicoes"][str(pai)][tipo].erase(i)
			GlobalManager.salvar_paciente_aberto()
			queue_free()









func _on_text_edit_text_changed() -> void:
	var texto := gramas.text.replace(",", ".")

	if texto.is_valid_float():
		valor_gramas = texto.to_float()


func _on_btn_mais_pressed() -> void:
	valor_gramas += 10.0
	gramas.text = str(valor_gramas)


func _on_btn_menos_pressed() -> void:
	valor_gramas -= 10.0

	if valor_gramas < 10.0:
		valor_gramas = 10.0

	gramas.text = str(valor_gramas)
