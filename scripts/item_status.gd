extends Panel

var data = {}

@onready var label: Label = $MarginContainer/Label
@onready var label_2: Label = $MarginContainer/Label2
@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel
@onready var check_box: CheckBox = $CheckBox
@onready var texture_button: TextureButton = $TextureButton

var v: Array[float] = []
var v2: Array[String] = []


var teste = false

func _ready() -> void:
	texture_button.visible = false
	if data.is_empty():
		queue_free()
		return
	
	#print(data)
	
	if teste == true:
		size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		custom_minimum_size.x = 100
		custom_minimum_size.y = 150
		check_box.visible = true
		texture_button.visible = true
	
	atualizar()


func atualizar():
	if data.has("titulo"):
		label.text = str(data["titulo"])
	
	if data.has("favoritado"):
		check_box.button_pressed = data["favoritado"]

	if data.has("valor_atual"):
		var a = str(data["valor_atual"])
		if data.has("medida"):
			a += str(" ",data["medida"])
		label_2.text = a

	if data.has("valor_atual") and data.has("ultimo_valor"):
		var valor_atual := float(data["valor_atual"])
		var ultimo_valor := float(data["ultimo_valor"])

		var diferenca := valor_atual - ultimo_valor

		if diferenca > 0:
			rich_text_label.text = "[color=72b879]↑ %s[/color]" % str(diferenca)

		elif diferenca < 0:
			rich_text_label.text = "[color=d95c5c]↓ %s[/color]" % str(abs(diferenca))

		else:
			rich_text_label.text = "[color=aaaaaa]→ 0[/color]"

		rich_text_label.bbcode_enabled = true


func _on_button_pressed() -> void:
	GlobalManager.atalhos["selecao_de_item"].v = v
	GlobalManager.atalhos["selecao_de_item"].v2 = v2
	GlobalManager.atalhos["selecao_de_item"].data = data
	GlobalManager.atalhos["selecao_de_item"].atualizar()
	GlobalManager.atalhos["selecao_de_item"].visible = true


func _on_check_box_toggled(toggled_on: bool) -> void:
	data["favoritado"] = toggled_on
	
	GlobalManager.salvar_paciente_aberto()
	pass # Replace with function body.


func _on_texture_button_pressed() -> void:
	if GlobalManager.atalhos["lista_status"].has_method('apagar'):
		GlobalManager.atalhos["lista_status"].apagar(data)
	pass # Replace with function body.
