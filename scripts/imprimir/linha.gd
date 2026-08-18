extends HBoxContainer

var dados = {}

func _ready() -> void:
	if dados.is_empty():
		queue_free()
		return
	
	add_to_group("tabela")
	
	$Panel2/MarginContainer/HBoxContainer/Label.text = dados["nome"]
	$Panel3/MarginContainer/HBoxContainer/Label.text = str(dados["gramas"])
	
	if dados.has("medida"):
		$Panel4/MarginContainer/HBoxContainer/LineEdit.text = str(dados["medida"])
	if dados.has("obser"):
		$Panel5/MarginContainer/HBoxContainer/LineEdit.text = str(dados["obser"])
	

func atualizar():
	dados["medida"] = $Panel4/MarginContainer/HBoxContainer/LineEdit.text
	dados["obser"] = $Panel5/MarginContainer/HBoxContainer/LineEdit.text
