extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_abrir_agenda_pressed() -> void:
	GlobalManager.abrir_tela("agenda")
	
