extends Control

@onready var lista_refeicoes: VBoxContainer = $MarginContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/lista_refeicoes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	limpar()

func limpar():
	if not GlobalManager.paciente_aberto.has("plano_alimentar"):
		GlobalManager.paciente_aberto["plano_alimentar"] = {
			"id_livre" : 1,
			"refeicoes" : {}
		}
		GlobalManager.salvar_paciente_aberto()
	
	for i in lista_refeicoes.get_children():
		i.queue_free()
	
	for i in GlobalManager.paciente_aberto["plano_alimentar"]['refeicoes']:
		adicionar_receita(i, GlobalManager.paciente_aberto["plano_alimentar"]['refeicoes'][i])

func _on_btn_abrir_nova_refeicao_pressed() -> void:
	var id = int(GlobalManager.paciente_aberto["plano_alimentar"]["id_livre"])
	var receita = {"id" : id}
	
	
	
	GlobalManager.paciente_aberto["plano_alimentar"]["refeicoes"][str(id)] = {} 
	
	adicionar_receita(id,{})
	
	GlobalManager.paciente_aberto["plano_alimentar"]["id_livre"] = id + 1
	
	GlobalManager.salvar_paciente_aberto()

func adicionar_receita(id,info):
	var aq = "res://prefab/plano_alimentar/refeicao.res"
	lista_refeicoes
	var i = {
		"id" : int(id),
		"data" : info
	}
	GlobalManager.adicionar_cena_como_filho(aq,lista_refeicoes,i)


func _on_btn_voltar_pressed() -> void:
	GlobalManager.atalhos["main"].abrir_tela("paciente")


func _on_btn_editar_medidor_pressed() -> void:
	$editar_medidores.visible = true


func _on_btn_imprimir_pressed() -> void:
	GlobalManager.atalhos["main"].abrir_tela("imprimir")
	pass # Replace with function body.
