extends Control


var info

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func _on_btn_fechar_anamnese_pressed() -> void:
	visible = false


func atualizar():
	if info['dados_pessoais'].has("nome"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/Label2.text = info['dados_pessoais']["nome"]
	
	if info['dados_pessoais'].has("nascimento"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer2/Label2.text = info['dados_pessoais']["nascimento"]
		
	if info['dados_pessoais'].has("sexo"):
		var sexo = int(info['dados_pessoais']["sexo"])
		var a = ""
		match sexo:
			0:
				a = "masculino"
			1:
				a = "feminino"
			_:
				a = "não informado"
		
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer3/Label2.text = a
		
	if info['dados_pessoais'].has("telefone"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer4/Label2.text = info['dados_pessoais']["telefone"]
	if info['dados_pessoais'].has("e-mail"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer5/Label2.text = info['dados_pessoais']["e-mail"]
	if info['dados_pessoais'].has("profissao"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer6/Label2.text = info['dados_pessoais']["profissao"]
	if info['dados_pessoais'].has("endereco"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer7/Label2.text = info['dados_pessoais']["endereco"]
	if info['dados_pessoais'].has("estado_civil"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer8/Label2.text = info['dados_pessoais']["estado_civil"]
	if info['dados_pessoais'].has("filhos"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer9/Label2.text = info['dados_pessoais']["filhos"]
	if info['objetivo'].has("objetivo"):
		var b
		match int(info['objetivo']["objetivo"]):
				0:
					b = "Emagrecimento"
				1:
					b = "Ganho de massa muscular"
				2:
					b = "Manutenção do peso"
				3:
					b = "Performance esportiva"
				4:
					b = "Melhora da saúde"
				_:
					b = "Outro"
					
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer10/Label2.text = b
	if info['objetivo'].has("o_que_espera_alcancar"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer11/Label2.text = info['objetivo']["o_que_espera_alcancar"]
	if info['dados_corporais'].has("peso_atual"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer12/Label2.text = info['dados_corporais']["peso_atual"]
	if info['dados_corporais'].has("altura"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer13/Label2.text = info['dados_corporais']["altura"]
	if info['dados_corporais'].has("peso_desejado"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer14/Label2.text = info['dados_corporais']["peso_desejado"]
	if info['dados_corporais'].has("circunferencia_da_cintura"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer17/Label2.text = info['dados_corporais']["circunferencia_da_cintura"]
	if info['dados_corporais'].has("circunferencia_do_quadril"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer16/Label2.text = info['dados_corporais']["circunferencia_do_quadril"]
	if info['dados_corporais'].has("porcentagem_de_gordura"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer17/Label2.text = info['dados_corporais']["porcentagem_de_gordura"]
	if info['historico'].has("doenca"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer18/Label2.text = info['historico']["doenca"]
	if info['historico'].has("cirurgia"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer19/Label2.text = info['historico']["cirurgia"]
	if info['historico'].has("alergias"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer20/Label2.text = info['historico']["alergias"]
	if info['historico'].has("medicamentos"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer21/Label2.text = info['historico']["medicamentos"]
	if info['historico'].has("suplementos"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer22/Label2.text = info['historico']["suplementos"]
	if info['historico'].has("historico_familiar"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer23/Label2.text = info['historico']["historico_familiar"]
	if info['habitos'].has("numero_de_refeicoes"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer24/Label2.text = info['habitos']["numero_de_refeicoes"]
	if info['habitos'].has("agua_por_dia"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer25/Label2.text = info['habitos']["agua_por_dia"]
	if info['habitos'].has("freq_refeicoes_fora"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer26/Label2.text = info['habitos']["freq_refeicoes_fora"]
	if info['habitos'].has("alimentos_que_gosta"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer27/Label2.text = info['habitos']["alimentos_que_gosta"]
	if info['habitos'].has("alimentos_que_nao_gosta"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer28/Label2.text = info['habitos']["alimentos_que_nao_gosta"]
	if info['habitos'].has("resticoes_alimentares"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer29/Label2.text = info['habitos']["resticoes_alimentares"]
	if info['habitos'].has("apetite"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer30/Label2.text = info['habitos']["apetite"]
	if not info["recordatorio"].is_empty():
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer31/Label2.text = info['recordatorio']
	
	if info['estilo_de_vida'].has("pratica_atividade"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer32/Label2.text = info['habitos']["pratica_atividade"]
	if info['estilo_de_vida'].has("qual_atividade"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer33/Label2.text = info['estilo_de_vidaitos']["qual_atividade"]
	if info['estilo_de_vida'].has("horas_sono"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer34/Label2.text = info['estilo_de_vida']["horas_sono"]
	if info['estilo_de_vida'].has("qualidade_sono"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer35/Label2.text = info['estilo_de_vida']["qualidade_sono"]
	if info['estilo_de_vida'].has("alcool"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer36/Label2.text = info['estilo_de_vida']["alcool"]
	if info['estilo_de_vida'].has("rotina"):
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer37/Label2.text = info['estilo_de_vida']["rotina"]
	if not info["informacoes_adicionais"].is_empty():
		$HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer38/Label2.text = info["informacoes_adicionais"]
