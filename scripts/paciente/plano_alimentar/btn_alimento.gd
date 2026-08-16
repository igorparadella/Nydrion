extends Button

var data = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = data["nome"]



func _on_pressed() -> void:
	GlobalManager.atalhos["Panel2_descricao_alimento"].mostar(data)
	#print(data)
	pass # Replace with function body.
