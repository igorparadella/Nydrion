extends Panel
@onready var label: Label = $MarginContainer/pendencia/Label

var dia
var paciente
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var horario = GlobalManager.config["agenda"][paciente]["consulta"]["horario"]
	var i = GlobalManager.carregar(str(GlobalManager.caminho,paciente,".json"))
	var nome = str(i["dados_pessoais"]["nome"])
	
	label.text = str(horario, " - ", nome)




func _on_check_box_toggled(toggled_on: bool) -> void:
	GlobalManager.config["agenda"].erase(paciente)
	queue_free()
	pass # Replace with function body.
