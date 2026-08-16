extends HBoxContainer
@onready var check_box: CheckBox = $CheckBox

var id
var dados = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if dados.is_empty():
		queue_free()
		return
		
	check_box.text = dados[0]
	check_box.button_pressed = dados[1]
	valor_atual = dados[2]
	valor.text = str(valor_atual)
	pass # Replace with function body.


func _on_check_box_toggled(toggled_on: bool) -> void:
	GlobalManager.atalhos["lista_medidores_visiveis"].filtros[id][1] = toggled_on
	pass # Replace with function body.

@onready var valor: TextEdit = $TextEdit

var valor_atual: float = 0.0
var incremento: float = 1.0



func _on_text_edit_text_changed() -> void:
	var texto := valor.text.strip_edges()

	if texto.is_empty():
		valor_atual = 0.0
		return

	# Troca vírgula por ponto
	texto = texto.replace(",", ".")

	# Tenta converter para float
	if texto.is_valid_float():
		valor_atual = texto.to_float()
		GlobalManager.atalhos["lista_medidores_visiveis"].filtros[id][2] = valor_atual
	else:
		# Remove caracteres inválidos
		var texto_corrigido := ""

		for caractere in texto:
			if caractere.is_valid_float() or caractere == ".":
				texto_corrigido += caractere

		valor.text = texto_corrigido
		valor.set_caret_line(0)
		GlobalManager.atalhos["lista_medidores_visiveis"].filtros[id][2] = texto_corrigido


func _on_btn_mais_pressed() -> void:
	valor_atual = valor.text.to_float()
	valor_atual += incremento

	valor.text = str(valor_atual)
	GlobalManager.atalhos["lista_medidores_visiveis"].filtros[id][2] = valor_atual


func _on_btn_menos_pressed() -> void:
	valor_atual = valor.text.to_float()
	valor_atual -= incremento
	GlobalManager.atalhos["lista_medidores_visiveis"].filtros[id][2] = valor_atual
	
	valor.text = str(valor_atual)
