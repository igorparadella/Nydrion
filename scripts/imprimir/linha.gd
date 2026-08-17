extends HBoxContainer

var dados = {}

func _ready() -> void:
	if dados.is_empty():
		queue_free()
		return
	
	$Panel2/MarginContainer/HBoxContainer/Label.text = dados["nome"]
	$Panel3/MarginContainer/HBoxContainer/Label.text = str(dados["gramas"])
	
