extends Panel
var id = 0

const DATA = {
	"dia" : 0,
	"alimentos" : [],
	"subistitutos" : []
}

var data = {}


@onready var lista_de_alimentos: VBoxContainer = $MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/Lista_de_alimentos
@onready var lista_de_substituicao: VBoxContainer = $MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/Lista_de_substituicao/Lista_de_substituicao2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if int(id) == 0:
		queue_free()
		return
	
	
	if GlobalManager.paciente_aberto["plano_alimentar"]["refeicoes"][str(id)].is_empty() or data.is_empty():
		data = DATA.duplicate(true)
		GlobalManager.paciente_aberto["plano_alimentar"]["refeicoes"][str(id)] = DATA.duplicate(true)
		GlobalManager.salvar_paciente_aberto()
	
	
	
	for i in lista_de_alimentos.get_children():
		i.queue_free()
	for i in lista_de_substituicao.get_children():
		i.queue_free()
	
	var aq = "res://prefab/plano_alimentar/alimento2.res"
	
	
	if data.has("alimentos"):
		for i in data["alimentos"]:
			var f = {"data" : i, "pai" : id, "tipo" : 'alimentos'}
			GlobalManager.adicionar_cena_como_filho(aq,lista_de_alimentos,f)
		for i in data["subistitutos"]:
			var f = {"data" : i, "pai" : id, "tipo" : 'subistitutos'}
			GlobalManager.adicionar_cena_como_filho(aq,lista_de_substituicao,f)
		
	pass # Replace with function body.




func _on_btn_remover_pressed() -> void:
	print("id: ",id)
	print(GlobalManager.paciente_aberto["plano_alimentar"]["refeicoes"])
	GlobalManager.paciente_aberto["plano_alimentar"]["refeicoes"].erase(str(id))
	GlobalManager.salvar_paciente_aberto()
	queue_free()
	
	pass # Replace with function body.


func _on_btn_adicionar_subtituicao_pressed() -> void:
	var d = {
		"id" : id,
		"tipo" : "subistitutos"
	}
	GlobalManager.atalhos["panel_novo_alimento"].escolher(d)
	pass # Replace with function body.


func _on_btn_adicionar_alimento_pressed() -> void:
	var d = {
		"id" : id,
		"tipo" : "alimentos"
	}
	GlobalManager.atalhos["panel_novo_alimento"].escolher(d)
	pass # Replace with function body.


func _on_option_button_dia_item_selected(index: int) -> void:
	GlobalManager.paciente_aberto["plano_alimentar"]["refeicoes"][str(id)]["dia"] = str(index)
	GlobalManager.salvar_paciente_aberto()

func _on_text_edit_horario_text_changed() -> void:
	GlobalManager.paciente_aberto["plano_alimentar"]["refeicoes"][str(id)]["horario"] = $MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/TextEdit_horario.text
	GlobalManager.salvar_paciente_aberto()
