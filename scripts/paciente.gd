extends Control
@onready var label_nome: Label = $ScrollContainer/VBoxContainer/HBoxContainer2/Panel2/MarginContainer/VBoxContainer/HBoxContainer2/Label_nome
@onready var label_data_nascimento: Label = $ScrollContainer/VBoxContainer/HBoxContainer2/Panel2/MarginContainer/VBoxContainer/HBoxContainer3/Label_data_nascimento
@onready var label_idade: Label = $ScrollContainer/VBoxContainer/HBoxContainer2/Panel2/MarginContainer/VBoxContainer/HBoxContainer4/Label_idade
@onready var label_telefone: Label = $ScrollContainer/VBoxContainer/HBoxContainer2/Panel2/MarginContainer/VBoxContainer/HBoxContainer5/Label_telefone
@onready var label_e_mail: Label = $ScrollContainer/VBoxContainer/HBoxContainer2/Panel2/MarginContainer/VBoxContainer/HBoxContainer6/Label_e_mail
@onready var label_profissao: Label = $ScrollContainer/VBoxContainer/HBoxContainer2/Panel2/MarginContainer/VBoxContainer/HBoxContainer8/Label_profissao
@onready var label_objetivo: Label = $ScrollContainer/VBoxContainer/HBoxContainer2/Panel2/MarginContainer/VBoxContainer/HBoxContainer9/Label_objetivo
@onready var label_estado_civil: Label = $ScrollContainer/VBoxContainer/HBoxContainer2/Panel2/MarginContainer/VBoxContainer/HBoxContainer10/Label_estado_civil
@onready var label_filhos: Label = $ScrollContainer/VBoxContainer/HBoxContainer2/Panel2/MarginContainer/VBoxContainer/HBoxContainer11/Label_filhos
@onready var label_nome_2: Label = $ScrollContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/Label_nome2
@onready var label_2_sexo: Label = $ScrollContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/label_2_sexo




@onready var label_refeicoes_dia: Label = $ScrollContainer/VBoxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer2/Label_refeicoes_dia
@onready var label_agua: Label = $ScrollContainer/VBoxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer3/Label_agua
@onready var label_atividade_fisica: Label = $ScrollContainer/VBoxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer4/Label_atividade_fisica
@onready var label_2_sono: Label = $ScrollContainer/VBoxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer5/Label2_sono
@onready var label_restricoes: Label = $ScrollContainer/VBoxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer6/Label_restricoes
@onready var label_2_alergias: Label = $ScrollContainer/VBoxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer7/Label2_alergias



@onready var panel: Panel = $Panel
@onready var agenda: Panel = $agenda
@onready var agenda2: MarginContainer = $agenda/HBoxContainer/VBoxContainer/MarginContainer


var info
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	info = GlobalManager.paciente_aberto
	GlobalManager.atalhos["paciente_tela"] = self
	
	panel.info = info
	panel.atualizar()
	
	if not info.is_empty() and info != {}:
		if info['dados_pessoais'].has("nome"):
			label_nome.text = info['dados_pessoais']["nome"]
			label_nome_2.text = info['dados_pessoais']["nome"]
		if info["dados_pessoais"].has("nascimento"):
			var data_nascimento: String = info["dados_pessoais"]["nascimento"]
			label_data_nascimento.text = info['dados_pessoais']["nascimento"]
			# Separa dia, mês e ano
			var partes = data_nascimento.split("/")

			if partes.size() == 3:
				var dia: int = int(partes[0])
				var mes: int = int(partes[1])
				var ano: int = int(partes[2])

				# Data atual
				var data_atual = Time.get_date_dict_from_system()

				var idade: int = data_atual["year"] - ano

				# Ainda não fez aniversário este ano
				if data_atual["month"] < mes or (
					data_atual["month"] == mes and data_atual["day"] < dia
				):
					idade -= 1

				label_2_sexo.text = str(idade) + " anos"
				label_idade.text = str(idade) + " anos"
		else:
			label_2_sexo.text = ""
		if info['dados_pessoais'].has("sexo"):
			var sexo = int(info['dados_pessoais']["sexo"])
			
			if sexo == 0:
				label_2_sexo.text += " - masculino"
			
			elif sexo == 1:
				label_2_sexo.text += " - feminino"
			else :
				label_2_sexo.text += " - não informado"
		
		if info['dados_pessoais'].has("telefone"):
			label_telefone.text = info['dados_pessoais']["telefone"]
		if info['dados_pessoais'].has("e-mail"):
			label_e_mail.text = info['dados_pessoais']["e-mail"]
		if info['dados_pessoais'].has("profissao"):
			label_profissao.text = info['dados_pessoais']["profissao"]
		if info['objetivo'].has("objetivo"):
			match int(info['objetivo']["objetivo"]):
				0:
					label_objetivo.text = "Emagrecimento"
				1:
					label_objetivo.text = "Ganho de massa muscular"
				2:
					label_objetivo.text = "Manutenção do peso"
				3:
					label_objetivo.text = "Performance esportiva"
				4:
					label_objetivo.text = "Melhora da saúde"
				_:
					label_objetivo.text = "Outro"
				
		if info['dados_pessoais'].has("estado_civil"):
			label_estado_civil.text = info['dados_pessoais']["estado_civil"]
		if info['dados_pessoais'].has("filhos"):
			label_filhos.text = info['dados_pessoais']["filhos"]
		
		if info['habitos'].has("numero_de_refeicoes"):
			label_refeicoes_dia.text = info['habitos']["numero_de_refeicoes"]
		if info['habitos'].has("agua_por_dia"):
			label_agua.text = info['habitos']["agua_por_dia"]
		if info['habitos'].has("numero_de_refeicoes"):
			label_atividade_fisica.text = info['habitos']["numero_de_refeicoes"]
		if info['estilo_de_vida'].has("sono"):
			label_2_sono.text = info['estilo_de_vida']["sono"]
		if info['estilo_de_vida'].has("resticoes_alimentares"):
			label_restricoes.text = info['estilo_de_vida']["resticoes_alimentares"]
		if info['historico'].has("alergias"):
			label_2_alergias.text = info['historico']["alergias"]
	pass # Replace with function body.




func _on_btn_ver_avaliacao_completa_pressed() -> void:
	GlobalManager.abrir_tela("avaliacao_atual")


func _on_btn_plano_alimentar_pressed() -> void:
	GlobalManager.abrir_tela("plano_alimentar")


func _on_btn_ver_anamnese_pressed() -> void:
	$Panel.visible = true
	pass # Replace with function body.
