extends HBoxContainer

@onready var dados_pessoais: Panel = $VBoxContainer/dados_pessoais
@onready var objetivo: Panel = $VBoxContainer/objetivo
@onready var dados: Panel = $VBoxContainer/dados
@onready var historico: Panel = $VBoxContainer/historico
@onready var habitos: Panel = $VBoxContainer/habitos
@onready var recordatorio: Panel = $VBoxContainer/recordatorio
@onready var estilo_de_vida: Panel = $VBoxContainer/estilo_de_vida
@onready var informacoes_adicionais: Panel = $VBoxContainer/informacoes_adicionais

var etapa = 0
var paciente = {
	"dados_pessoais" : {},
	"objetivo" : {},
	"dados_corporais" : {},
	"historico" : {},
	"habitos" : {},
	"estilo_de_vida" : {},
	"recordatorio" : {},
	"informacoes_adicionais" : {},
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	paciente["dados_pessoais"]["sexo"] = 0
	paciente["objetivo"]["objetivo"] = 0
	mostar_etapa()
	pass # Replace with function body.

func mostar_etapa():
	var etapas = [dados_pessoais,objetivo,dados,historico,habitos,recordatorio,estilo_de_vida,informacoes_adicionais]
	
	for i in etapas:
		i.visible = false
	
	etapas[etapa].visible = true




func _on_btn_next_pressed() -> void:
	etapa += 1
	mostar_etapa()


func _on_btn_prev_pressed() -> void:
	etapa -= 1
	mostar_etapa()


func _on_btn_confirmar_pressed() -> void:
	if paciente["dados_pessoais"].has('nome') and paciente["dados_pessoais"]["nome"] and paciente["dados_pessoais"]["nome"] != null:
		
		var aq = str("paciente_",int(GlobalManager.config["id_livre"]),".json")
		

		
		paciente["arquivo"] = aq
		paciente["id"] = str("paciente_",int(GlobalManager.config["id_livre"]))
		
		GlobalManager.config["id_livre"] += 1
		GlobalManager.salvar_config()
		GlobalManager.salvar(paciente,str(GlobalManager.caminho,aq))
		
		
		GlobalManager.pacientes[paciente["dados_pessoais"]["nome"]] = aq
		
		
		GlobalManager.salvar(GlobalManager.pacientes,str(GlobalManager.caminho,"pacientes.json"))
		
		GlobalManager.paciente_aberto = GlobalManager.carregar(str(GlobalManager.caminho,aq))
		
		GlobalManager.abrir_tela("paciente")
	else:
		GlobalManager.notificar("Erro","É necessário um nome para o paciente")



func _on_text_edit_nome_text_changed() -> void:
	paciente["dados_pessoais"]["nome"] = $VBoxContainer/dados_pessoais/MarginContainer/VBoxContainer/HBoxContainer/TextEdit_nome.text


func _on_text_edit_data_de_nascimento_text_changed() -> void:
	paciente["dados_pessoais"]["nascimento"] = $VBoxContainer/dados_pessoais/MarginContainer/VBoxContainer/HBoxContainer2/TextEdit_data_de_nascimento.text

func _on_option_button_sexo_item_selected(index: int) -> void:
	paciente["dados_pessoais"]["sexo"] = index


func _on_text_edit_telefone_text_changed() -> void:
	paciente["dados_pessoais"]["telefone"] = $VBoxContainer/dados_pessoais/MarginContainer/VBoxContainer/HBoxContainer4/TextEdit_telefone.text


func _on_text_edit_e_mail_text_changed() -> void:
	paciente["dados_pessoais"]["e-mail"] = $VBoxContainer/dados_pessoais/MarginContainer/VBoxContainer/HBoxContainer5/TextEdit_e_mail.text


func _on_text_edit_profissao_text_changed() -> void:
	paciente["dados_pessoais"]["profissao"] = $VBoxContainer/dados_pessoais/MarginContainer/VBoxContainer/HBoxContainer6/TextEdit_profissao.text
	pass # Replace with function body.


func _on_text_edit_endreco_text_changed() -> void:
	paciente["dados_pessoais"]["endreco"] = $VBoxContainer/dados_pessoais/MarginContainer/VBoxContainer/HBoxContainer7/TextEdit_endreco.text
	pass # Replace with function body.


func _on_text_edit_estado_civil_text_changed() -> void:
	paciente["dados_pessoais"]["estado_civil"] = $VBoxContainer/dados_pessoais/MarginContainer/VBoxContainer/HBoxContainer8/TextEdit_estado_civil.text
	pass # Replace with function body.


func _on_text_edit_filhos_text_changed() -> void:
	paciente["dados_pessoais"]["filhos"] = $VBoxContainer/dados_pessoais/MarginContainer/VBoxContainer/HBoxContainer9/TextEdit_filhos.text
	pass # Replace with function body.







func _on_text_edit_o_que_espera_alcancar_text_changed() -> void:
	paciente["objetivo"]["o_que_espera_alcancar"] = $VBoxContainer/objetivo/MarginContainer/VBoxContainer/TextEdit_o_que_espera_alcancar.text


func _on_option_button_objetivo_item_selected(index: int) -> void:
	paciente["objetivo"]["objetivo"] = index


func _on_text_edit_peso_atual_text_changed() -> void:
	paciente["dados_corporais"]["peso_atual"] = $VBoxContainer/dados/MarginContainer/VBoxContainer/HBoxContainer/TextEdit_peso_atual.text
	pass # Replace with function body.


func _on_text_edit_altura_text_changed() -> void:
	paciente["dados_corporais"]["altura"] = $VBoxContainer/dados/MarginContainer/VBoxContainer/HBoxContainer2/TextEdit_altura.text
	pass # Replace with function body.


func _on_text_edit_peso_desejado_text_changed() -> void:
	paciente["dados_corporais"]["peso_desejado"] = $VBoxContainer/dados/MarginContainer/VBoxContainer/HBoxContainer3/TextEdit_peso_desejado.text
	pass # Replace with function body.


func _on_text_edit_circunferencia_da_cintura_text_changed() -> void:
	paciente["dados_corporais"]["circunferencia_da_cintura"] = $VBoxContainer/dados/MarginContainer/VBoxContainer/HBoxContainer4/TextEdit_circunferencia_da_cintura.text
	pass # Replace with function body.


func _on_text_edit_circunferencia_do_quadril_text_changed() -> void:
	paciente["dados_corporais"]["circunferencia_do_quadril"] = $VBoxContainer/dados/MarginContainer/VBoxContainer/HBoxContainer5/TextEdit_circunferencia_do_quadril.text
	pass # Replace with function body.


func _on_text_edit_porcentagem_de_gordura_text_changed() -> void:
	paciente["dados_corporais"]["porcentagem_de_gordura"] = $VBoxContainer/dados/MarginContainer/VBoxContainer/HBoxContainer6/TextEdit_porcentagem_de_gordura.text
	pass # Replace with function body.


func _on_text_edit_doenca_text_changed() -> void:
	paciente["historico"]["doenca"] = $VBoxContainer/historico/MarginContainer/VBoxContainer/HBoxContainer/TextEdit_doenca.text


func _on_text_edit_cirurgia_text_changed() -> void:
	paciente["historico"]["cirurgia"] = $VBoxContainer/historico/MarginContainer/VBoxContainer/HBoxContainer2/TextEdit_cirurgia.text
	pass # Replace with function body.


func _on_text_edit_alergias_text_changed() -> void:
	paciente["historico"]["alergias"] = $VBoxContainer/historico/MarginContainer/VBoxContainer/HBoxContainer3/TextEdit_alergias.text
	pass # Replace with function body.


func _on_text_edit_medicamentos_text_changed() -> void:
	paciente["historico"]["medicamentos"] = $VBoxContainer/historico/MarginContainer/VBoxContainer/HBoxContainer4/TextEdit_medicamentos.text
	pass # Replace with function body.


func _on_text_edit_suplementos_text_changed() -> void:
	paciente["historico"]["suplementos"] = $VBoxContainer/historico/MarginContainer/VBoxContainer/HBoxContainer5/TextEdit_suplementos.text
	pass # Replace with function body.


func _on_text_edit_historico_familiar_text_changed() -> void:
	paciente["historico"]["historico_familiar"] = $VBoxContainer/historico/MarginContainer/VBoxContainer/HBoxContainer6/TextEdit_historico_familiar.text
	pass # Replace with function body.


func _on_text_edit_numero_de_refeicoes_text_changed() -> void:
	paciente["habitos"]["numero_de_refeicoes"] = $VBoxContainer/habitos/MarginContainer/VBoxContainer/HBoxContainer/TextEdit_numero_de_refeicoes.text
	pass # Replace with function body.


func _on_text_edit_agua_por_dia_text_changed() -> void:
	paciente["habitos"]["agua_por_dia"] = $VBoxContainer/habitos/MarginContainer/VBoxContainer/HBoxContainer2/TextEdit_agua_por_dia.text
	pass # Replace with function body.


func _on_text_edit_freq_refeicoes_fora_text_changed() -> void:
	paciente["habitos"]["freq_refeicoes_fora"] = $VBoxContainer/habitos/MarginContainer/VBoxContainer/HBoxContainer3/TextEdit_freq_refeicoes_fora.text
	pass # Replace with function body.


func _on_text_edit_alimentos_que_gosta_text_changed() -> void:
	paciente["habitos"]["alimentos_que_gosta"] = $VBoxContainer/habitos/MarginContainer/VBoxContainer/HBoxContainer4/TextEdit_alimentos_que_gosta.text
	pass # Replace with function body.


func _on_text_edit_alimentos_que_nao_gosta_text_changed() -> void:
	paciente["habitos"]["alimentos_que_nao_gosta"] = $VBoxContainer/habitos/MarginContainer/VBoxContainer/HBoxContainer5/TextEdit_alimentos_que_nao_gosta.text
	pass # Replace with function body.


func _on_text_edit_resticoes_alimentares_text_changed() -> void:
	paciente["habitos"]["resticoes_alimentares"] = $VBoxContainer/habitos/MarginContainer/VBoxContainer/HBoxContainer6/TextEdit_resticoes_alimentares.text
	pass # Replace with function body.


func _on_text_edit_apetite_text_changed() -> void:
	paciente["habitos"]["apetite"] = $VBoxContainer/habitos/MarginContainer/VBoxContainer/HBoxContainer7/TextEdit_apetite.text
	pass # Replace with function body.


func _on_text_edit_recordatorio_text_changed() -> void:
	paciente["recordatorio"] = $VBoxContainer/recordatorio/MarginContainer/VBoxContainer/TextEdit_recordatorio.text


func _on_text_edit_outro_text_changed() -> void:
	paciente["informacoes_adicionais"] = $VBoxContainer/informacoes_adicionais/MarginContainer/VBoxContainer/TextEdit_outro.text
	pass # Replace with function body.


func _on_text_edit_pratica_atividade_text_changed() -> void:
	paciente["estilo_de_vida"]["pratica_atividade"] = $VBoxContainer/estilo_de_vida/MarginContainer/VBoxContainer/HBoxContainer/TextEdit_pratica_atividade.text


func _on_text_edit_qual_atividade_text_changed() -> void:
	paciente["estilo_de_vida"]["qual_atividade"] = $VBoxContainer/estilo_de_vida/MarginContainer/VBoxContainer/HBoxContainer2/TextEdit_qual_atividade.text


func _on_text_edit_horas_sono_text_changed() -> void:
	paciente["estilo_de_vida"]["horas_sono"] = $VBoxContainer/estilo_de_vida/MarginContainer/VBoxContainer/HBoxContainer3/TextEdit_horas_sono.text
	pass # Replace with function body.


func _on_text_edit_qualidade_sono_text_changed() -> void:
	paciente["estilo_de_vida"]["qualidade_sono"] = $VBoxContainer/estilo_de_vida/MarginContainer/VBoxContainer/HBoxContainer4/TextEdit_qualidade_sono.text
	pass # Replace with function body.


func _on_text_edit_alcool_text_changed() -> void:
	paciente["estilo_de_vida"]["alcool"] = $VBoxContainer/estilo_de_vida/MarginContainer/VBoxContainer/HBoxContainer5/TextEdit_alcool.text
	pass # Replace with function body.


func _on_text_edit_rotina_text_changed() -> void:
	paciente["estilo_de_vida"]["rotina"] = $VBoxContainer/estilo_de_vida/MarginContainer/VBoxContainer/TextEdit_rotina.text
	pass # Replace with function body.
