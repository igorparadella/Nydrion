extends Panel

var data = {}

@onready var label: Label = $MarginContainer/Panel/MarginContainer2/VBoxContainer/HBoxContainer/VBoxContainer/Label
@onready var label_2: Label = $MarginContainer/Panel/MarginContainer2/VBoxContainer/HBoxContainer/VBoxContainer/Label2
@onready var control: Control = $MarginContainer/Panel/MarginContainer2/VBoxContainer/HBoxContainer2/Panel/MarginContainer/VBoxContainer/Control


@onready var text_edit_v: TextEdit = $MarginContainer/Panel/MarginContainer2/VBoxContainer/HBoxContainer2/VBoxContainer/Panel2/MarginContainer/VBoxContainer/HBoxContainer/TextEdit
@onready var text_edit_d: TextEdit = $MarginContainer/Panel/MarginContainer2/VBoxContainer/HBoxContainer2/VBoxContainer/Panel2/MarginContainer/VBoxContainer/HBoxContainer2/TextEdit
@onready var anotacao: TextEdit = $MarginContainer/Panel/MarginContainer2/VBoxContainer/HBoxContainer2/VBoxContainer/Panel2/MarginContainer/VBoxContainer/TextEdit


var v: Array[float] = []
var v2: Array[String] = []

var limitar_grafico := 10


func _ready() -> void:
	GlobalManager.atalhos["selecao_de_item"] = self
	visible = false


func atualizar() -> void:
	anotacao.text = ""
	
	label_limite.text = str(limitar_grafico)

	if data.has("titulo"):
		label.text = data["titulo"]

	if data.has("descricao"):
		label_2.text = data["descricao"]

	if data.has("valores"):
		v = GlobalManager.array_para_float(data["valores"])

	if data.has("anotacao"):
		anotacao.text = data["anotacao"]


	if data.has("datas"):
		v2 = GlobalManager.array_para_string(data["datas"])

	# Mantém somente os últimos valores
	if v.size() > limitar_grafico:
		v = v.slice(v.size() - limitar_grafico, v.size())

	# Mantém somente as datas correspondentes
	if v2.size() > limitar_grafico:
		v2 = v2.slice(v2.size() - limitar_grafico, v2.size())

	control.valores = v
	control.etiquetas_x = v2

	control.queue_redraw()

	# Atualiza as opções de correção
	atualizar_opcoes_correcao()
	
	GlobalManager.atalhos["lista_status"].atualizar()



func _on_btn_fechar_selecao_pressed() -> void:
	visible = false



func _on_btn_salvar_novo_dado_pressed() -> void:
	#print("==========================================")
	#print(GlobalManager.paciente_aberto)
	#print("==========================================")
	#print(data)
	
	for i in GlobalManager.paciente_aberto['avalicao']:
		for a in GlobalManager.paciente_aberto['avalicao'][i]:
			#print(str(GlobalManager.paciente_aberto['avalicao'][i][a]," ==== ",data["titulo"]))
			if str(GlobalManager.paciente_aberto['avalicao'][i][a]) == str(data["titulo"]):
				
				if GlobalManager.paciente_aberto['avalicao'][i].has("valor_atual"):
					GlobalManager.paciente_aberto['avalicao'][i]["ultimo_valor"] = GlobalManager.paciente_aberto['avalicao'][i]["valor_atual"]
				
				GlobalManager.paciente_aberto['avalicao'][i]["valor_atual"] = extrair_valor(text_edit_v.text)
				
				if GlobalManager.paciente_aberto['avalicao'][i].has("valores"):
					GlobalManager.paciente_aberto['avalicao'][i]["valores"].append(float(text_edit_v.text))
				else:
					GlobalManager.paciente_aberto['avalicao'][i]["valores"] = []
					GlobalManager.paciente_aberto['avalicao'][i]["valores"].append(float(text_edit_v.text))
					
				if GlobalManager.paciente_aberto['avalicao'][i].has("datas"):
					GlobalManager.paciente_aberto['avalicao'][i]["datas"].append(str(text_edit_d.text))
				else:
					GlobalManager.paciente_aberto['avalicao'][i]["datas"] = []
					GlobalManager.paciente_aberto['avalicao'][i]["datas"].append(str(text_edit_d.text))
				
				GlobalManager.paciente_aberto['avalicao'][i]["anotacao"] = anotacao.text
				
				GlobalManager.salvar_paciente_aberto()
	
	text_edit_v.text = ""
	text_edit_d.text = ""
	#print("==========================================")
	#print(GlobalManager.paciente_aberto)
	#print("==========================================")
	atualizar()


@onready var label_limite: Label = $MarginContainer/Panel/MarginContainer2/VBoxContainer/HBoxContainer2/Panel/MarginContainer/VBoxContainer/HBoxContainer/Label_limite

func _on_btn_diminuir_pressed() -> void:
	if limitar_grafico > 2:
		limitar_grafico -= 1
		atualizar()


func _on_btn_aumentar_pressed() -> void:
	limitar_grafico += 1
	atualizar()



@onready var text_edit_valor_corrigido: TextEdit = $MarginContainer/Panel/MarginContainer2/VBoxContainer/HBoxContainer2/VBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/TextEdit
@onready var option_button_data_para_corrigir: OptionButton = $MarginContainer/Panel/MarginContainer2/VBoxContainer/HBoxContainer2/VBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer2/OptionButton

func atualizar_opcoes_correcao() -> void:
	option_button_data_para_corrigir.clear()

	for i in range(v2.size()):
		var data_texto := str(v2[i])
		var valor_texto := str(v[i])

		option_button_data_para_corrigir.add_item(
			data_texto + " - " + valor_texto
		)

		# Guarda o índice original como ID da opção
		option_button_data_para_corrigir.set_item_id(
			option_button_data_para_corrigir.item_count - 1,
			i
		)

func _on_btn_salvar_correcao_pressed() -> void:
	# Verifica se existem dados
	if v.is_empty() or v2.is_empty():
		return

	# Verifica se alguma data foi selecionada
	var indice := option_button_data_para_corrigir.get_selected_id()

	if indice < 0 or indice >= v.size():
		push_error("Índice de correção inválido.")
		return

	# Verifica se o novo valor é realmente numérico
	var texto := text_edit_valor_corrigido.text.strip_edges()

	if texto.is_empty():
		push_error("Digite um valor para corrigir.")
		return

	if not texto.is_valid_float():
		push_error("O valor informado não é um número válido.")
		return

	# Converte o novo valor
	var novo_valor := float(texto)

	# Corrige o valor no mesmo índice da data
	v[indice] = novo_valor

	# Atualiza o Dictionary original
	data["valores"] = v

	# Limpa o campo
	text_edit_valor_corrigido.text = ""

	# Atualiza gráfico e OptionButton
	atualizar()

func extrair_valor(texto: String) -> float:
	var regex = RegEx.new()
	regex.compile(r"[-+]?\d+(?:[.,]\d+)?")
	
	var resultado = regex.search(texto)
	
	if resultado:
		return float(resultado.get_string().replace(",", "."))
	
	return 0.0
