extends Panel

var id = null
var data = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if id == null:
		queue_free()
		return
	
	$MarginContainer/HBoxContainer/Label.text = data["nome"]



func _on_button_pressed() -> void:
	GlobalManager.paciente_aberto["plano_alimentar"] = data["dados"].duplicate(true)
	GlobalManager.salvar_paciente_aberto()
	GlobalManager.atalhos["main"].abrir_tela("plano_alimentar")


func _on_texture_button_pressed() -> void:
	print("aaaaaaaaaaaaaaaaaa")
	GlobalManager.config["plano_alimentar_modelos"]["modelos"].erase(id)
	GlobalManager.salvar_config()
	GlobalManager.atalhos["lista_modelos"].carregar_modelos()
	queue_free()
