extends MarginContainer

@onready var grade: GridContainer = $HBoxContainer/Control/Panel/MarginContainer/VBoxContainer/GridContainer
@onready var mes_ano: Label = $HBoxContainer/Control/Panel/MarginContainer/VBoxContainer/HBoxContainer/Label2

var mes_atual: int
var ano_atual: int

var paciente = false

func _ready() -> void:
	$Panel.visible = false
	GlobalManager.atalhos["agenda"] = self
	var data_atual = Time.get_datetime_dict_from_system()

	mes_atual = data_atual["month"]
	ano_atual = data_atual["year"]

	atualizar_calendario()


func atualizar_calendario() -> void:
	for filho in grade.get_children():
		filho.queue_free()

	mes_ano.text = nome_mes(mes_atual) + " " + str(ano_atual)

	# Descobre em qual dia da semana o mês começa
	var primeiro_dia = Time.get_datetime_dict_from_datetime_string(
		"%04d-%02d-01 00:00:00" % [ano_atual, mes_atual],
		true
	)

	var unix_primeiro = Time.get_unix_time_from_datetime_dict(primeiro_dia)
	var dia_semana = Time.get_datetime_dict_from_unix_time(unix_primeiro)["weekday"]

	# Quantidade de dias do mês atual
	var dias_atual = dias_do_mes(mes_atual, ano_atual)

	# Mês anterior
	var mes_anterior = mes_atual - 1
	var ano_anterior = ano_atual

	if mes_anterior < 1:
		mes_anterior = 12
		ano_anterior -= 1

	var dias_anterior = dias_do_mes(mes_anterior, ano_anterior)

	# Mês seguinte
	var mes_seguinte = mes_atual + 1
	var ano_seguinte = ano_atual

	if mes_seguinte > 12:
		mes_seguinte = 1
		ano_seguinte += 1

	# Cria as 42 células
	for i in range(42):
		var numero_dia: int
		var mes_dia: int
		var ano_dia: int
		var outro_mes := false

		# Mês anterior
		if i < dia_semana:
			numero_dia = dias_anterior - dia_semana + i + 1
			mes_dia = mes_anterior
			ano_dia = ano_anterior
			outro_mes = true

		# Mês atual
		elif i < dia_semana + dias_atual:
			numero_dia = i - dia_semana + 1
			mes_dia = mes_atual
			ano_dia = ano_atual

		# Mês seguinte
		else:
			numero_dia = i - (dia_semana + dias_atual) + 1
			mes_dia = mes_seguinte
			ano_dia = ano_seguinte
			outro_mes = true

		var data_string = "%d_%d_%d" % [
			numero_dia,
			mes_dia,
			ano_dia
		]

		# Seu GlobalManager espera Dictionary
		var dados = {
			"data": data_string,
			"dia": numero_dia,
			"mes": mes_dia,
			"ano": ano_dia,
			"mes_atual": mes_atual
		}

		GlobalManager.adicionar_cena_como_filho(
			"res://prefab/agenda/dia.res",
			grade,
			dados
		)


func dias_do_mes(mes: int, ano: int) -> int:
	match mes:
		1, 3, 5, 7, 8, 10, 12:
			return 31

		4, 6, 9, 11:
			return 30

		2:
			if ano % 400 == 0:
				return 29

			if ano % 100 == 0:
				return 28

			if ano % 4 == 0:
				return 29

			return 28

	return 30


func nome_mes(mes: int) -> String:
	match mes:
		1: return "Janeiro"
		2: return "Fevereiro"
		3: return "Março"
		4: return "Abril"
		5: return "Maio"
		6: return "Junho"
		7: return "Julho"
		8: return "Agosto"
		9: return "Setembro"
		10: return "Outubro"
		11: return "Novembro"
		12: return "Dezembro"

	return ""


func _on_btn_prev_pressed() -> void:
	mes_atual -= 1

	if mes_atual < 1:
		mes_atual = 12
		ano_atual -= 1

	atualizar_calendario()


func _on_btn_next_pressed() -> void:
	mes_atual += 1

	if mes_atual > 12:
		mes_atual = 1
		ano_atual += 1

	atualizar_calendario()


func _on_btn_cancelar_pressed() -> void:
	$Panel/Panel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/TextEdit.text = ""
	$Panel.visible = false
	pass # Replace with function body.

var temp = ""
@onready var consultas_no_dia: Panel = $HBoxContainer/Panel

func click(quem):
	if paciente == true:
		$Panel.visible = true
		var temp = str(quem.dia,"_",quem.mes,"_",quem.ano)
		var v = str(quem.dia,"/",quem.mes,"/",quem.ano)
		$Panel/Panel/MarginContainer/VBoxContainer/VBoxContainer/Label2.text = v
	
	else:
		consultar_agenda(quem)
	
	pass

func hover(quem):
	if paciente == true:
		consultar_agenda(quem)
	
	pass
@onready var lista_consultas: VBoxContainer = $HBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/lista_consultas

func consultar_agenda(quem):
	var d = str(quem.dia,"/",quem.mes,"/",quem.ano)
	
	for i in lista_consultas.get_children():
		i.queue_free()
	
	for i in GlobalManager.config['agenda']:
		if GlobalManager.config['agenda'][i]["consulta"]["dia"] == d:
			var aq = "res://prefab/agenda/consulta.res"
			var v = {
				'dia' : d,
				'paciente' : i,
			}
			GlobalManager.adicionar_cena_como_filho(aq,lista_consultas,v)
		
	
	
	pass


func _on_btn_marcar_pressed() -> void:
	GlobalManager.config["agenda"][GlobalManager.paciente_aberto["id"]] = {}
	GlobalManager.config["agenda"][GlobalManager.paciente_aberto["id"]]["consulta"] = {
		"dia" : $Panel/Panel/MarginContainer/VBoxContainer/VBoxContainer/Label2.text,
		"horario" : $Panel/Panel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/TextEdit.text
	}
	
	temp = ""
	$Panel.visible = false
	GlobalManager.atalhos["paciente_tela"].agenda.visible = false
	
	GlobalManager.salvar_config()
	pass # Replace with function body.
