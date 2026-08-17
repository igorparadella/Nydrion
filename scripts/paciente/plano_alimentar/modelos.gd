extends Panel

@onready var lista_modelos: VBoxContainer = $HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	GlobalManager.atalhos["lista_modelos"] = self
	
	limpar()
	if GlobalManager.config.has('plano_alimentar_modelos'):
		carregar_modelos()
	else:
		GlobalManager.config["plano_alimentar_modelos"] = {
			"id_livre" : 1,
			"modelos" : {}
		}

func _on_btn_modelos_pressed() -> void:
	visible = true
	pass # Replace with function body.


func _on_btn_fechar_pressed() -> void:
	visible = false
	$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/TextEdit.text = ""


func carregar_modelos():
	limpar()
	var aq = "res://prefab/plano_alimentar/opcao_modelo.res"
	lista_modelos
	
	for i in GlobalManager.config["plano_alimentar_modelos"]["modelos"]:
		var v = {
			"id" : i,
			"data" : GlobalManager.config["plano_alimentar_modelos"]["modelos"][i]
		}
		GlobalManager.adicionar_cena_como_filho(aq,lista_modelos,v)

func limpar():
	for i in lista_modelos.get_children():
		i.queue_free()



func _on_btn_salvar_pressed() -> void:
	var nome = $HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/TextEdit.text
	
	if nome != null and nome != "":
		GlobalManager.config["plano_alimentar_modelos"]["modelos"][int(GlobalManager.config["plano_alimentar_modelos"]["id_livre"])] = {
			"nome" : nome,
			"dados" : GlobalManager.paciente_aberto["plano_alimentar"].duplicate(true)
		}
		
		GlobalManager.config["plano_alimentar_modelos"]["id_livre"] = int(GlobalManager.config["plano_alimentar_modelos"]["id_livre"]) + 1
		GlobalManager.salvar_config()
		carregar_modelos()
	else:
		GlobalManager.notificar("Erro", "É necessário um nome para adicionar um modelo")
