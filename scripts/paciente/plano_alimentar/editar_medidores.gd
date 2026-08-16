extends Panel

var filtros = {
	"calcio_mg": ["Cálcio (mg)", false, 7000],
	"carboidratos_g": ["Carboidratos (g)", true, 2100],
	"cinzas_g": ["Cinzas (g)", false, 0],
	"colesterol_mg": ["Colesterol (mg)", false, 2100],
	"energia_kcal": ["Energia (kcal)", true, 15400],
	"energia_kj": ["Energia (kJ)", false, 64400],
	"ferro_mg": ["Ferro (mg)", false, 56],
	"fibra_alimentar_g": ["Fibra alimentar (g)", true, 175],
	"lipideos_g": ["Lipídeos (g)", true, 455],
	"magnesio_mg": ["Magnésio (mg)", false, 2800],
	"manganes_mg": ["Manganês (mg)", false, 16.1],
	"fosforo_mg": ["Fósforo (mg)", false, 4900],
	"niacina_mg": ["Niacina (mg)", false, 112],
	"retinol_mcg": ["Retinol (µg)", false, 6300],
	"rae_mcg": ["RAE (µg)", false, 6300],
	"re_mcg": ["RE (µg)", false, 6300],
	"piridoxina_mg": ["Piridoxina (mg)", false, 9.1],
	"potassio_mg": ["Potássio (mg)", false, 23800],
	"riboflavina_mg": ["Riboflavina (mg)", false, 9.1],
	"sodio_mg": ["Sódio (mg)", true, 14000],
	"tiamina_mg": ["Tiamina (mg)", false, 8.4],
	"umidade_pct": ["Umidade (%)", false, 0],
	"vitamina_c_mg": ["Vitamina C (mg)", false, 630],
	"zinco_mg": ["Zinco (mg)", false, 77],
}


@onready var medidores: VBoxContainer = $HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/medidores
@onready var medidores_atalho: VBoxContainer = $"../MarginContainer/HBoxContainer/VBoxContainer/Panel3/MarginContainer/VBoxContainer/VBoxContainer/ScrollContainer/medidores_atalho"

func _ready() -> void:
	visible = false
	GlobalManager.atalhos["lista_medidores_visiveis"] = self
	var aq = "res://prefab/plano_alimentar/editar_limite_medidor.res"
	for i in filtros:
		var d = {"id": i, "dados" : filtros[i]}
		GlobalManager.adicionar_cena_como_filho(aq,medidores,d)
	
	
	var aq2 = "res://prefab/plano_alimentar/medidor.res"
	await limpar()
	for i in filtros:
		if filtros[i][1] == true:
			var d = {"id": i, "dados" : filtros[i]}
			GlobalManager.adicionar_cena_como_filho(aq2,medidores_atalho,d)


func _on_btn_fechar_pressed() -> void:
	visible = false
	var aq2 = "res://prefab/plano_alimentar/medidor.res"
	await limpar()
	for i in filtros:
		if filtros[i][1] == true:
			var d = {"id": i, "dados" : filtros[i]}
			GlobalManager.adicionar_cena_como_filho(aq2,medidores_atalho,d)

func limpar():
	for i in medidores_atalho.get_children():
		i.queue_free()
