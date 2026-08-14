extends Panel

var dia
var data: Dictionary = {}
var mes
var ano
var mes_atual

@onready var label: Label = $MarginContainer/Label

@onready var panel: Panel = $MarginContainer/Panel


func _ready() -> void:
	panel.visible = false
	
	label.text = str(dia)

	var data_atual := Time.get_date_dict_from_system()

	var dia2: int = data_atual.day
	var mes2: int = data_atual.month


	var estilo := StyleBoxFlat.new()

	if dia2 == dia and mes2 == mes:
		estilo.bg_color = Color("8ad291ff")
	
	elif  mes != mes_atual:
		estilo.bg_color = Color("e8f9e8ff")
	else:
		estilo.bg_color = Color("ffffffff")

	# Borda
	estilo.border_color = Color("72b879ff")
	estilo.border_width_bottom = 2
	estilo.border_width_left = 2
	estilo.border_width_right = 2
	estilo.border_width_top = 2

	# Cantos arredondados
	estilo.corner_radius_top_left = 16
	estilo.corner_radius_top_right = 16
	estilo.corner_radius_bottom_left = 16
	estilo.corner_radius_bottom_right = 16



	# Aplica ao Panel
	add_theme_stylebox_override("panel", estilo)
	
				
				
	var d = str(dia,"/",mes,"/",ano)
	for i in GlobalManager.config['agenda']:
		#print(GlobalManager.config['agenda'])
		if GlobalManager.config['agenda'][i]["consulta"]["dia"] == d:
			panel.visible = true

func _on_button_pressed() -> void:
	GlobalManager.atalhos["agenda"].click(self)


func _on_button_mouse_entered() -> void:
	GlobalManager.atalhos["agenda"].hover(self)
	
