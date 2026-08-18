extends Control
@onready var refeicoes: VBoxContainer = $MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/VBoxContainer
var dados = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in GlobalManager.paciente_aberto["plano_alimentar"]["refeicoes"]:
		var aq = "res://prefab/imprimir/tabela.res"
		var v = {
			"data" : GlobalManager.paciente_aberto["plano_alimentar"]["refeicoes"][i]
		}
		GlobalManager.adicionar_cena_como_filho(aq,refeicoes,v)
	$MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer2/Panel2/MarginContainer/VBoxContainer/LineEdit.text = obter_data_atual()
	$MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer2/Panel/MarginContainer/VBoxContainer/LineEdit.text = GlobalManager.paciente_aberto["dados_pessoais"]["nome"]
	#
	$MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer2/Panel3/MarginContainer/VBoxContainer/LineEdit.text = obter_abjetivo()
	
	if GlobalManager.info.has('dados'):
		if GlobalManager.info["dados"].has('clinica'):
			if GlobalManager.info["dados"]["clinica"].has('icone'):
				carregar_logo(GlobalManager.info["dados"]["clinica"]["icone"])
				$MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/Button.visible = false
				$MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/logo.visible = true
			else:
				$MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/Button.visible = true
				$MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/logo.visible = false
			
			if GlobalManager.info["dados"]["clinica"].has('telefone'):
				$MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer4/VBoxContainer2/LineEdit.text = GlobalManager.info["dados"]["clinica"]["telefone"]
			if GlobalManager.info["dados"]["clinica"].has('instagram'):
				$MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer4/VBoxContainer2/LineEdit2.text = GlobalManager.info["dados"]["clinica"]["instagram"]
	


func obter_abjetivo():
	var a = int(GlobalManager.paciente_aberto["objetivo"]["objetivo"])
	
	match a:
		_:
			return "emagrecer"
		
	
	
	return ""

func _on_btn_voltar_pressed() -> void:
	GlobalManager.abrir_tela("plano_alimentar")



func _on_btn_imprimir_pressed() -> void:
	var aq = "res://prefab/plano_alimentar/imprimir.tscn"
	var destino = $Control
	checar()
	
	var v = {
		"dados" : dados
	}
	await GlobalManager.adicionar_cena_como_filho(aq,destino,v)
	
	var i = destino.get_child(0)
	i.imprimir()

func checar():
	dados["telefone"] = $MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer4/VBoxContainer2/LineEdit.text
	dados["e-mail"] = $MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer4/VBoxContainer2/LineEdit2.text
	dados["orientacoes_gerais"] = $MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/Panel3/MarginContainer/VBoxContainer/TextEdit.text
	dados["orientacao"] = $MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/Panel/MarginContainer/HBoxContainer/LineEdit.text
	dados["objetivo"] = $MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer2/Panel3/MarginContainer/VBoxContainer/LineEdit.text
	dados["data"] = $MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer2/Panel2/MarginContainer/VBoxContainer/LineEdit.text
	dados["nome"] = $MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer2/Panel/MarginContainer/VBoxContainer/LineEdit.text
	dados["icone"] = $MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/logo.texture
	
	
	for nodo in get_tree().get_nodes_in_group("tabela"):
		if nodo.has_method("atualizar"):
			nodo.atualizar()
	
	GlobalManager.salvar_paciente_aberto()

func carregar_logo(caminho: String) -> void:
	if not FileAccess.file_exists(caminho):
		printerr("Arquivo não encontrado: ", caminho)
		return
	
	var arquivo := FileAccess.open(caminho, FileAccess.READ)
	var dados := arquivo.get_buffer(arquivo.get_length())
	arquivo.close()

	var imagem := Image.new()
	var erro := imagem.load_svg_from_buffer(dados)

	if erro != OK:
		printerr("Erro ao carregar imagem: ", erro)
		return

	$MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/logo.texture = ImageTexture.create_from_image(imagem)

func obter_data_atual() -> String:
	var data = Time.get_date_dict_from_system()

	return "%02d/%02d/%04d" % [
		data["day"],
		data["month"],
		data["year"]
	]

func _on_button_pressed() -> void:
	pass # Replace with function body.
