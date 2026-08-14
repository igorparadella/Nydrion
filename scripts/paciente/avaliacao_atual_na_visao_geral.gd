extends Panel

@onready var grade: GridContainer = $MarginContainer/VBoxContainer/ScrollContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	atualizar()
	GlobalManager.atalhos["lista_status"] = self

func atualizar():
	for i in grade.get_children():
		i.queue_free()
	
	
	if GlobalManager.paciente_aberto.has("avalicao"):
		for i in GlobalManager.paciente_aberto['avalicao']:
			if GlobalManager.paciente_aberto['avalicao'][i].has('favoritado'):
				if GlobalManager.paciente_aberto['avalicao'][i]["favoritado"] == true:
					var aquivo = "res://prefab/paciente/item_status.res"
					var data = {"data" : GlobalManager.paciente_aberto['avalicao'][i]}
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
		
