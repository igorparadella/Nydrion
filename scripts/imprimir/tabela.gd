extends VBoxContainer

var data = {}

@onready var alimentos: VBoxContainer = $VBoxContainer/VBoxContainer

@onready var substituicoes: VBoxContainer = $VBoxContainer2/VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if data.is_empty():
		queue_free()
		return
	
	for i in alimentos.get_children():
		i.queue_free()
	for i in substituicoes.get_children():
		i.queue_free()
	
	var aq = "res://prefab/imprimir/linha.res"
	
	$Panel/MarginContainer/HBoxContainer/Label.text = achar_dia(data["dia"])
	
	for i in data["alimentos"]:
		var v = {"dados" : i}
		GlobalManager.adicionar_cena_como_filho(aq,alimentos,v)
	
	for i in data["subistitutos"]:
		var v = {"dados" : i}
		GlobalManager.adicionar_cena_como_filho(aq,substituicoes,v)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func achar_dia(d):
	match int(d):
		0:
			return "Domingo"
		1:
			return "Segunda"
		2:
			return "Terça"
		3:
			return "Quarta"
		4:
			return "Quinta"
		5:
			return "Sexta"
		6:
			return "Sabádo"
		_:
			return "Todos os dias"
	
	
	
	return ""
