extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalManager.config['agenda'].has(GlobalManager.paciente_aberto["id"]):
		$MarginContainer/VBoxContainer/VBoxContainer.visible = true
		$MarginContainer/VBoxContainer/VBoxContainer2.visible = false
	else:
		$MarginContainer/VBoxContainer/VBoxContainer.visible = false
		$MarginContainer/VBoxContainer/VBoxContainer2.visible = true
		
	
	atualizar()
	pass # Replace with function body.



func _on_desmarcar_pressed() -> void:
	if GlobalManager.config['agenda'].has(GlobalManager.paciente_aberto["id"]):
		GlobalManager.config['agenda'].erase(GlobalManager.paciente_aberto["id"])
		GlobalManager.salvar_config()
	$MarginContainer/VBoxContainer/VBoxContainer.visible = false
	$MarginContainer/VBoxContainer/VBoxContainer2.visible = true


func _on_reagendar_pressed() -> void:
	if GlobalManager.config['agenda'].has(GlobalManager.paciente_aberto["id"]):
		GlobalManager.config['agenda'].erase(GlobalManager.paciente_aberto["id"])
		GlobalManager.salvar_config()
	agendar()



func _on_agendar_pressed() -> void:
	if GlobalManager.config['agenda'].has(GlobalManager.paciente_aberto["id"]):
		GlobalManager.config['agenda'].erase(GlobalManager.paciente_aberto["id"])
		GlobalManager.salvar_config()
	agendar()


func agendar():
	if GlobalManager.atalhos.has("paciente_tela"):
		GlobalManager.atalhos["paciente_tela"].agenda2.paciente = true
		GlobalManager.atalhos["paciente_tela"].agenda2.atualizar_calendario()
		GlobalManager.atalhos["paciente_tela"].agenda.visible = true
		$MarginContainer/VBoxContainer/VBoxContainer.visible = true
		$MarginContainer/VBoxContainer/VBoxContainer2.visible = false
		atualizar()


func atualizar():
	if GlobalManager.config['agenda'].has(GlobalManager.paciente_aberto["id"]):
		var c = GlobalManager.config['agenda'][GlobalManager.paciente_aberto["id"]]["consulta"]
		var t = str(c["dia"]," - ",c["horario"])
		$MarginContainer/VBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/Label2.text = t
	pass
