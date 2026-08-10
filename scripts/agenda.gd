extends Node

@onready var seg: VBoxContainer = $Panel/MarginContainer/VBoxContainer/HBoxContainer3/Seg
@onready var ter: VBoxContainer = $Panel/MarginContainer/VBoxContainer/HBoxContainer3/Ter
@onready var qua: VBoxContainer = $Panel/MarginContainer/VBoxContainer/HBoxContainer3/Qua
@onready var qui: VBoxContainer = $Panel/MarginContainer/VBoxContainer/HBoxContainer3/Qui
@onready var sex: VBoxContainer = $Panel/MarginContainer/VBoxContainer/HBoxContainer3/Sex
@onready var sáb: VBoxContainer = $Panel/MarginContainer/VBoxContainer/HBoxContainer3/Sáb
@onready var dom: VBoxContainer = $Panel/MarginContainer/VBoxContainer/HBoxContainer3/Dom

var pai


@onready var mes_e_ano: Label = $Panel/MarginContainer/VBoxContainer/HBoxContainer/Label2


# ==========================================
# MÊS EXIBIDO
# ==========================================

var mes_exibido: int
var ano_exibido: int


# ==========================================
# DATA ATUAL
# ==========================================

var dia_atual: int
var mes_atual: int
var ano_atual: int


# ==========================================
# NOMES DOS MESES
# ==========================================

var nomes_meses = [
	"",
	"Janeiro",
	"Fevereiro",
	"Março",
	"Abril",
	"Maio",
	"Junho",
	"Julho",
	"Agosto",
	"Setembro",
	"Outubro",
	"Novembro",
	"Dezembro"
]


# ==========================================
# READY
# ==========================================

func _ready():

	var data = Time.get_datetime_dict_from_system()

	dia_atual = data.day
	mes_atual = data.month
	ano_atual = data.year

	mes_exibido = mes_atual
	ano_exibido = ano_atual

	atualizar_calendario()


# ==========================================
# ATUALIZA CALENDÁRIO
# ==========================================

func atualizar_calendario():

	mes_e_ano.text = nomes_meses[mes_exibido] + " " + str(ano_exibido)

	limpar_calendario()


	# ==========================================
	# PRIMEIRO DIA DO MÊS
	# ==========================================

	var primeiro_dia = {
		"year": ano_exibido,
		"month": mes_exibido,
		"day": 1,
		"hour": 12,
		"minute": 0,
		"second": 0
	}

	var timestamp = Time.get_unix_time_from_datetime_dict(primeiro_dia)

	var data_primeiro = Time.get_datetime_dict_from_unix_time(timestamp)

	# 0 = Domingo
	# 1 = Segunda
	# ...
	# 6 = Sábado

	var primeiro_dia_semana = data_primeiro.weekday


	# ==========================================
	# DIAS DO MÊS ATUAL
	# ==========================================

	var total_dias = dias_no_mes(
		mes_exibido,
		ano_exibido
	)


	# ==========================================
	# MÊS ANTERIOR
	# ==========================================

	var mes_anterior = mes_exibido - 1
	var ano_anterior = ano_exibido

	if mes_anterior < 1:
		mes_anterior = 12
		ano_anterior -= 1


	var total_dias_anterior = dias_no_mes(
		mes_anterior,
		ano_anterior
	)


	# ==========================================
	# PREENCHE AS 42 CÉLULAS
	# ==========================================

	for posicao in range(42):

		# ==========================================
		# DIA DA SEMANA
		# ==========================================

		var dia_semana = posicao % 7


		# ==========================================
		# SEMANA
		# ==========================================

		var semana = int(posicao / 7)


		# ==========================================
		# PEGA O VBOX
		# ==========================================

		var vbox = pegar_dia_semana(dia_semana)

		if vbox == null:
			continue


		# ==========================================
		# PEGA O PANEL
		# ==========================================

		var panel = pegar_panel(vbox, semana)

		if panel == null:
			continue


		# ==========================================
		# CALCULA O DIA
		# ==========================================

		var dia_calendario = posicao - primeiro_dia_semana + 1


		# ==========================================
		# MÊS ANTERIOR
		# ==========================================

		if dia_calendario < 1:

			var dia = total_dias_anterior + dia_calendario

			preencher_panel(
				panel,
				dia,
				false,
				false
			)


		# ==========================================
		# MÊS ATUAL
		# ==========================================

		elif dia_calendario <= total_dias:

			var eh_hoje = (
				dia_calendario == dia_atual
				and mes_exibido == mes_atual
				and ano_exibido == ano_atual
			)

			preencher_panel(
				panel,
				dia_calendario,
				true,
				eh_hoje
			)


		# ==========================================
		# PRÓXIMO MÊS
		# ==========================================

		else:

			var dia = dia_calendario - total_dias

			preencher_panel(
				panel,
				dia,
				false,
				false
			)


# ==========================================
# PREENCHE PANEL
# ==========================================

func preencher_panel(
	panel: Panel,
	dia: int,
	mes_atual: bool,
	eh_hoje: bool
):

	var label = panel.get_node("Label") as Label

	label.text = str(dia)


	# ==========================================
	# OUTRO MÊS
	# ==========================================

	if not mes_atual:

		panel.self_modulate = Color(
			0.55,
			0.55,
			0.55,
			1.0
		)


	# ==========================================
	# HOJE
	# ==========================================

	elif eh_hoje:

		panel.self_modulate = Color(
			0.0,
			0.914,
			0.0,
			1.0
		)


	# ==========================================
	# DIA NORMAL
	# ==========================================

	else:

		panel.self_modulate = Color(
			1.0,
			1.0,
			1.0,
			1.0
		)


# ==========================================
# PEGA O VBOX
# ==========================================

func pegar_dia_semana(dia_semana: int) -> VBoxContainer:

	match dia_semana:

		0:
			return dom

		1:
			return seg

		2:
			return ter

		3:
			return qua

		4:
			return qui

		5:
			return sex

		6:
			return sáb

	return null


# ==========================================
# PEGA O PANEL DA SEMANA
# ==========================================

func pegar_panel(
	d: VBoxContainer,
	semana: int
) -> Panel:

	if semana == 0:
		return d.get_node("Panel") as Panel

	return d.get_node(
		"Panel" + str(semana + 1)
	) as Panel


# ==========================================
# LIMPA CALENDÁRIO
# ==========================================

func limpar_calendario():

	var dias = [
		seg,
		ter,
		qua,
		qui,
		sex,
		sáb,
		dom
	]

	for vbox in dias:

		for child in vbox.get_children():

			if child is Panel:

				var panel = child as Panel

				var label = panel.get_node(
					"Label"
				) as Label

				label.text = ""

				panel.self_modulate = Color(
					1.0,
					1.0,
					1.0,
					1.0
				)


# ==========================================
# DIAS DO MÊS
# ==========================================

func dias_no_mes(
	mes: int,
	ano: int
) -> int:

	match mes:

		1:
			return 31

		2:

			if (
				ano % 4 == 0
				and (
					ano % 100 != 0
					or ano % 400 == 0
				)
			):

				return 29

			return 28

		3:
			return 31

		4:
			return 30

		5:
			return 31

		6:
			return 30

		7:
			return 31

		8:
			return 31

		9:
			return 30

		10:
			return 31

		11:
			return 30

		12:
			return 31

	return 0


# ==========================================
# NOME DO DIA DA SEMANA
# ==========================================

func nome_dia_semana(
	dia_semana: int
) -> String:

	match dia_semana:

		0:
			return "Domingo"

		1:
			return "Segunda-feira"

		2:
			return "Terça-feira"

		3:
			return "Quarta-feira"

		4:
			return "Quinta-feira"

		5:
			return "Sexta-feira"

		6:
			return "Sábado"

	return "Desconhecido"


# ==========================================
# PREV
# ==========================================

func _on_btn_prev_pressed() -> void:

	mes_exibido -= 1

	if mes_exibido < 1:

		mes_exibido = 12
		ano_exibido -= 1

	atualizar_calendario()


# ==========================================
# NEXT
# ==========================================

func _on_btn_next_pressed() -> void:

	mes_exibido += 1

	if mes_exibido > 12:

		mes_exibido = 1
		ano_exibido += 1

	atualizar_calendario()
