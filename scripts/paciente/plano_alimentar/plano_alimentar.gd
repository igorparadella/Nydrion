extends Control

@onready var lista_refeicoes: VBoxContainer = $MarginContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/lista_refeicoes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not GlobalManager.paciente_aberto.has("plano_alimentar"):
		GlobalManager.paciente_aberto["plano_alimentar"] = []
		GlobalManager.salvar_paciente_aberto()
	

func _on_btn_abrir_nova_refeicao_pressed() -> void:
	var n = GlobalManager.paciente_aberto["plano_alimentar"].size() + 1
	
	var receita = {
		"id" : n
	}
	
	GlobalManager.paciente_aberto["plano_alimentar"].append(receita.duplicate(true))
	adicionar_receita(n)
	print(GlobalManager.paciente_aberto)
	GlobalManager.salvar_paciente_aberto()

func adicionar_receita(id):
	var aq = "res://prefab/plano_alimentar/refeicao.res"
	lista_refeicoes
	var i = {
		"id" : id
	}
	GlobalManager.adicionar_cena_como_filho(aq,lista_refeicoes,i)
