extends Control

@onready var selecao_de_item: Panel = $selecao_de_item
@onready var criacao_de_item: Panel = $criacao_de_item
@onready var grade: GridContainer = $MarginContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/GridContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalManager.atalhos["lista_status"] = self
	selecao_de_item.visible = false
	criacao_de_item.visible = false
	atualizar()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func abrir(data):
	selecao_de_item.visible = true
	

func _on_btn_fechar_selecao_pressed() -> void:
	selecao_de_item.visible = false
	pass # Replace with function body.


func _on_btn_voltar_pressed() -> void:
	GlobalManager.abrir_tela("paciente")
	pass # Replace with function body.


func _on_btn_novo_item_pressed() -> void:
	criacao_de_item.visible = true


func _on_btn_editar_pressed() -> void:
	pass # Replace with function body.


func _on_btn_fechar_criacao_de_item_pressed() -> void:
	criacao_de_item.visible = false


func atualizar():
	for i in grade.get_children():
		i.queue_free()
	
	
	if GlobalManager.paciente_aberto.has("avalicao"):
		for i in GlobalManager.paciente_aberto['avalicao']:
			var aquivo = "res://prefab/paciente/item_status.res"
			var data = {"data" : GlobalManager.paciente_aberto['avalicao'][i],
			'teste' : true
			}
			
			GlobalManager.adicionar_cena_como_filho(aquivo,grade,data)
			
	else:
		GlobalManager.paciente_aberto['avalicao'] = {
			"peso": {
				"titulo": "Peso",
				"favoritado": true,
				"medida": "kg"
			},
			"altura": {
				"titulo": "Altura",
				"favoritado": true,
				"medida": "cm"
			},
			"imc": {
				"titulo": "IMC",
				"favoritado": true,
				"medida": "kg/m²"
			},
			"cintura": {
				"titulo": "Cintura",
				"favoritado": true,
				"medida": "cm"
			},
			"quadril": {
				"titulo": "Quadril",
				"favoritado": true,
				"medida": "cm"
			},
			"massa_magra": {
				"titulo": "Massa magra",
				"favoritado": true,
				"medida": "kg"
			},
			"meta": {
				"titulo": "Meta",
				"favoritado": true,
				"medida": "kg"
			},
			"braco": {
				"titulo": "Braço",
				"favoritado": true,
				"medida": "cm"
			},
			"panturrilha": {
				"titulo": "Panturrilha",
				"favoritado": true,
				"medida": "cm"
			},
			"pescoco": {
				"titulo": "Pescoço",
				"favoritado": true,
				"medida": "cm"
			},
			"p_arterial": {
				"titulo": "P. Arterial",
				"favoritado": true,
				"medida": "mmHg"
			},
			"gordura": {
				"titulo": "Gordura",
				"favoritado": true,
				"medida": "%"
			},
		}
		GlobalManager.salvar_paciente_aberto()
		atualizar()



func _on_btn_salvar_novo_item_pressed() -> void:
	var titulo = $criacao_de_item/Panel/MarginContainer/VBoxContainer/HBoxContainer/TextEdit.text
	
	
	
	var medida = $criacao_de_item/Panel/MarginContainer/VBoxContainer/HBoxContainer3/TextEdit.text
	
	var descricao = $criacao_de_item/Panel/MarginContainer/VBoxContainer/HBoxContainer4/TextEdit.text
	
	
	
	GlobalManager.paciente_aberto['avalicao'][GlobalManager.normalizar_texto(titulo)] = {
		'titulo' : titulo,
		'medida' : medida,
		'descricao' : descricao,
		"favoritado" : false
	}
	
	
	atualizar()
	#GlobalManager.salvar_paciente_aberto()
	pass # Replace with function body.


var ds = {}
func apagar(d):
	$criacao_de_item2.visible = true
	ds = d
	$criacao_de_item2/Panel/MarginContainer/VBoxContainer/Label3.text = str(d["titulo"])


func _on_btn_cancelar_pressed() -> void:
	$criacao_de_item2.visible = false
	ds = {}
	pass # Replace with function body.


func _on_btn_apagar_pressed() -> void:
	for i in GlobalManager.paciente_aberto['avalicao']:
		if GlobalManager.paciente_aberto['avalicao'][i]["titulo"] == ds['titulo']:
			GlobalManager.paciente_aberto['avalicao'].erase(i)
			
	
	GlobalManager.salvar_paciente_aberto()
	atualizar()
	
	$criacao_de_item2.visible = false
