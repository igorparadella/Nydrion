extends Panel
var aq2 = "res://prefab/plano_alimentar/medidor.res"
var filtros
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if 	GlobalManager.paciente_aberto.has("medidores"):
		filtros = GlobalManager.paciente_aberto["medidores"]
		for i in filtros:
			if filtros[i][1] == true:
				var d = {"id": i, "dados" : filtros[i]}
				GlobalManager.adicionar_cena_como_filho(aq2,v_box_container,d)
