extends Control

@onready var refeicoes: VBoxContainer = $MarginContainer/HBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/VBoxContainer
@onready var label: Label = $MarginContainer/HBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/Panel3/MarginContainer/VBoxContainer/Label
var dados = {
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in GlobalManager.paciente_aberto["plano_alimentar"]["refeicoes"]:
		var aq = "res://prefab/imprimir/tabela.res"
		var v = {
			"data" : GlobalManager.paciente_aberto["plano_alimentar"]["refeicoes"][i]
		}
		GlobalManager.adicionar_cena_como_filho(aq,refeicoes,v)



func _on_btn_voltar_pressed() -> void:
	GlobalManager.abrir_tela("plano_alimentar")



func _on_btn_imprimir_pressed() -> void:
	var aq = "res://prefab/plano_alimentar/imprimir.tscn"
	var destino = $Control
	var v = {
		"dados" : dados
	}
	await GlobalManager.adicionar_cena_como_filho(aq,destino,v)
	
	var i = destino.get_child(0)
	i.imprimir()
