extends Control

@onready var dados_pessoais: Panel = $VBoxContainer2/HBoxContainer/dados_pessoais
@onready var dados_profissionais: Panel = $VBoxContainer2/HBoxContainer/dados_profissionais
@onready var endereco: Panel = $VBoxContainer2/HBoxContainer/endereco
@onready var clinica: Panel = $VBoxContainer2/HBoxContainer/clinica
@onready var acesso: Panel = $VBoxContainer2/HBoxContainer/acesso


var etapa = 0

var info = {
	"usuario" : null,
	"senha" : null,
	"senha2" : null,
	"primeiro_acesso" : true,
	"dados" : {
		"pessoal" : {},
		"profissional" : {},
		"endereco" : {},
		"clinica" : {},
	}
}



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer.visible = true
	$VBoxContainer2.visible = false
	$VBoxContainer3.visible = false
	
	
	var a = carregar_atalho()
	if a:
		var usuario = carregar_usuario(a["usuario"],a["senha"])
	
		if usuario != null:
			GlobalManager.info = usuario
			get_tree().change_scene_to_file("res://cenas/main.tscn")
			pass # Replace with function body.



func mostar_etapa(n):
	var etapas = [dados_pessoais,dados_profissionais,endereco,clinica,acesso]
	
	for i in etapas:
		i.visible = false
	
	etapas[n].visible = true
	pass

func _on_btn_iniciar_cadastro_pressed() -> void:
	$VBoxContainer.visible = false
	$VBoxContainer2.visible = true
	mostar_etapa(etapa)


func _on_btn_login_pressed() -> void:
	$VBoxContainer.visible = false
	$VBoxContainer3.visible = true


func _on_btn_voltar_b_v_pressed() -> void:
	etapa = 0
	$VBoxContainer.visible = true
	$VBoxContainer2.visible = false
	$VBoxContainer3.visible = false


func _on_btn_next_pressed() -> void:
	etapa += 1
	mostar_etapa(etapa)


func _on_btn_prev_pressed() -> void:
	etapa -= 1
	mostar_etapa(etapa)


func _on_btn_finalizar_cadastro_pressed() -> void:
	etapa = 0
	#print(info)
	
	if info["senha"] != info["senha"]:
		printerr("erro na senha")
		return
	
	if info["usuario"] == null or info["usuario"] == null:
		printerr("erro no nome de usuario")
		return
	
	await salvar_usuario(info)
	
	etapa = 0
	$VBoxContainer.visible = false
	$VBoxContainer2.visible = false
	$VBoxContainer3.visible = true
	pass # Replace with function body.

func salvar_usuario(info: Dictionary) -> bool:
	var usuario: String = str(info.get("usuario", "")).strip_edges()

	if usuario.is_empty():
		push_error("Usuário não informado.")
		return false

	# --------------------------------------------------------
	# Senha do usuário
	# --------------------------------------------------------

	var senha: String = str(info.get("senha", ""))

	if senha.is_empty():
		senha = "senha_padrao_123"

	# --------------------------------------------------------
	# Pasta principal
	# --------------------------------------------------------

	var pasta_base := "user://usuarios"

	# Pasta específica do usuário
	var pasta_usuario := pasta_base.path_join(usuario)

	# --------------------------------------------------------
	# Cria a pasta
	# --------------------------------------------------------

	var erro := DirAccess.make_dir_recursive_absolute(
		ProjectSettings.globalize_path(pasta_usuario)
	)

	if erro != OK and erro != ERR_ALREADY_EXISTS:
		push_error(
			"Erro ao criar pasta do usuário: " + str(erro)
		)
		return false

	# --------------------------------------------------------
	# Caminho do JSON
	# --------------------------------------------------------

	var caminho_json := pasta_usuario.path_join(
		usuario + ".json"
	)

	# --------------------------------------------------------
	# Faz uma cópia dos dados
	# --------------------------------------------------------

	var dados_usuario := info.duplicate(true)

	# --------------------------------------------------------
	# IMPORTANTE:
	# Não precisamos salvar a senha dentro do arquivo.
	#
	# A própria senha é usada para criptografar o arquivo.
	# --------------------------------------------------------

	dados_usuario.erase("senha2")



	# --------------------------------------------------------
	# Converte tudo para JSON
	# --------------------------------------------------------

	var json_texto := JSON.stringify(
		dados_usuario,
		"\t"
	)

	# --------------------------------------------------------
	# ABRE O ARQUIVO CRIPTOGRAFADO
	# --------------------------------------------------------

	var arquivo := FileAccess.open_encrypted_with_pass(
		caminho_json,
		FileAccess.WRITE,
		senha
	)

	if arquivo == null:
		push_error(
			"Não foi possível criar o arquivo criptografado."
		)
		return false

	# --------------------------------------------------------
	# Salva o JSON inteiro criptografado
	# --------------------------------------------------------

	arquivo.store_string(json_texto)
	arquivo.close()

	#print("====================================")
	#print("Usuário salvo com sucesso!")
	#print("Usuário: ", usuario)
	#print("Arquivo: ", caminho_json)
	#print("Arquivo criptografado: SIM")
	#print("====================================")

	return true


func carregar_usuario(usuario: String, senha: String):
	usuario = usuario.strip_edges()

	if usuario.is_empty():
		push_error("Usuário não informado.")
		return null

	if senha.is_empty():
		printerr("Senha não informada.")
		return null

	# --------------------------------------------------------
	# Caminho do usuário
	# --------------------------------------------------------

	var pasta_usuario := "user://usuarios".path_join(
		usuario
	)

	var caminho_json := pasta_usuario.path_join(
		usuario + ".json"
	)

	# --------------------------------------------------------
	# Verifica se o usuário existe
	# --------------------------------------------------------

	if not FileAccess.file_exists(caminho_json):
		printerr("Usuário não encontrado: ", usuario)
		return null

	# --------------------------------------------------------
	# Tenta abrir/descriptografar
	# --------------------------------------------------------

	var arquivo := FileAccess.open_encrypted_with_pass(
		caminho_json,
		FileAccess.READ,
		senha
	)

	# --------------------------------------------------------
	# Se não conseguiu abrir, provavelmente a senha está errada
	# --------------------------------------------------------

	if arquivo == null:
		printerr("Usuário ou senha incorretos.")
		return null

	# --------------------------------------------------------
	# Lê o conteúdo já descriptografado
	# --------------------------------------------------------

	var texto := arquivo.get_as_text()

	arquivo.close()

	# --------------------------------------------------------
	# Converte JSON
	# --------------------------------------------------------

	var resultado = JSON.parse_string(texto)

	if resultado == null:
		push_error(
			"Não foi possível interpretar os dados do usuário."
		)
		return null

	if not resultado is Dictionary:
		push_error(
			"Os dados do usuário não são um Dictionary."
		)
		return null

	# --------------------------------------------------------
	# Login realizado
	# --------------------------------------------------------

	#print("====================================")
	#print("Login realizado com sucesso!")
	#print("Usuário: ", usuario)
	#print("====================================")

	return resultado





func _on_btn_confirmar_login_pressed() -> void:
	var usuario = carregar_usuario($VBoxContainer3/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer5/TextEdit.text, $VBoxContainer3/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer3/TextEdit.text)

	if usuario != null:
		if $VBoxContainer3/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer4/CheckBox.button_pressed:
			var data = {
				"usuario" : $VBoxContainer3/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer5/TextEdit.text,
				"senha" : $VBoxContainer3/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer3/TextEdit.text,
			}
			
			escrever_atalho(data)
		
		GlobalManager.info = usuario
		
		get_tree().change_scene_to_file("res://cenas/main.tscn")
	else:
		printerr("Usuário ou senha incorretos.")
	
	
	
	
	pass # Replace with function body.


const CAMINHO_ATALHO := "user://atalho.json"


# ============================================================
# ESCREVER / SALVAR
# ============================================================

const SENHA_ATALHO := "NutriPro_2026_Chave_Atalho"


# ============================================================
# ESCREVER / SALVAR
# ============================================================

func escrever_atalho(dados: Dictionary) -> bool:
	var arquivo := FileAccess.open_encrypted_with_pass(
		CAMINHO_ATALHO,
		FileAccess.WRITE,
		SENHA_ATALHO
	)

	if arquivo == null:
		push_error(
			"Não foi possível abrir o arquivo de atalhos para escrita. Erro: "
			+ str(FileAccess.get_open_error())
		)
		return false

	var json := JSON.stringify(dados, "\t")

	arquivo.store_string(json)
	arquivo.close()

	return true


# ============================================================
# CARREGAR
# ============================================================

func carregar_atalho() -> Dictionary:
	if not FileAccess.file_exists(CAMINHO_ATALHO):
		return {}

	var arquivo := FileAccess.open_encrypted_with_pass(
		CAMINHO_ATALHO,
		FileAccess.READ,
		SENHA_ATALHO
	)

	if arquivo == null:
		push_error(
			"Não foi possível abrir/descriptografar o arquivo de atalhos. "
			+ "A senha pode estar incorreta ou o arquivo pode estar corrompido."
		)
		return {}

	var texto := arquivo.get_as_text()
	arquivo.close()

	var json := JSON.new()
	var erro := json.parse(texto)

	if erro != OK:
		push_error(
			"Erro ao ler atalho.json: "
			+ json.get_error_message()
		)
		return {}

	if typeof(json.data) != TYPE_DICTIONARY:
		push_error(
			"O arquivo atalho.json não contém um Dictionary."
		)
		return {}

	return json.data



func _on_text_edit_nome_text_changed() -> void:
	info["dados"]["pessoal"]["nome"] = $VBoxContainer2/HBoxContainer/dados_pessoais/MarginContainer/VBoxContainer/HBoxContainer/TextEdit_nome.text

func _on_text_edit_cpf_text_changed() -> void:
	info["dados"]["pessoal"]["cpf"] = $VBoxContainer2/HBoxContainer/dados_pessoais/MarginContainer/VBoxContainer/HBoxContainer3/TextEdit_cpf.text

func _on_text_edit_data_de_nascimento_text_changed() -> void:
	info["dados"]["pessoal"]["data_de_nascimento"] = $VBoxContainer2/HBoxContainer/dados_pessoais/MarginContainer/VBoxContainer/HBoxContainer4/TextEdit_data_de_nascimento.text
	pass # Replace with function body.

func _on_text_edit_crn_text_changed() -> void:
	info["dados"]["profissional"]["crn"] = $VBoxContainer2/HBoxContainer/dados_profissionais/MarginContainer/VBoxContainer/HBoxContainer/TextEdit_crn.text


func _on_text_edit_regiao_crn_text_changed() -> void:
	info["dados"]["profissional"]["regiao_crn"] = $VBoxContainer2/HBoxContainer/dados_profissionais/MarginContainer/VBoxContainer/HBoxContainer3/TextEdit_regiao_crn.text


func _on_text_edit_especialidade_text_changed() -> void:
	info["dados"]["profissional"]["especialidade"] = $VBoxContainer2/HBoxContainer/dados_profissionais/MarginContainer/VBoxContainer/HBoxContainer4/TextEdit_especialidade.text



func _on_text_edit_formacao_text_changed() -> void:
	info["dados"]["profissional"]["formacao"] = $VBoxContainer2/HBoxContainer/dados_profissionais/MarginContainer/VBoxContainer/HBoxContainer5/TextEdit_formacao.text


func _on_text_edit_instituicao_text_changed() -> void:
	info["dados"]["profissional"]["instituicao"] = $VBoxContainer2/HBoxContainer/dados_profissionais/MarginContainer/VBoxContainer/HBoxContainer6/TextEdit_instituicao.text






func _on_text_edit_cep_text_changed() -> void:
	info["dados"]["endereco"]["cep"] = $VBoxContainer2/HBoxContainer/endereco/MarginContainer/VBoxContainer/HBoxContainer/TextEdit_cep.text


func _on_text_edit_rua_text_changed() -> void:
	info["dados"]["endereco"]["rua"] = $VBoxContainer2/HBoxContainer/endereco/MarginContainer/VBoxContainer/HBoxContainer3/TextEdit_rua.text


func _on_text_edit_numero_text_changed() -> void:
	info["dados"]["endereco"]["numero"] = $VBoxContainer2/HBoxContainer/endereco/MarginContainer/VBoxContainer/HBoxContainer4/TextEdit_numero.text


func _on_text_edit_complemento_text_changed() -> void:
	info["dados"]["endereco"]["complemento"] = $VBoxContainer2/HBoxContainer/endereco/MarginContainer/VBoxContainer/HBoxContainer5/TextEdit_complemento.text


func _on_text_edit_cidade_text_changed() -> void:
	info["dados"]["endereco"]["cidade"] = $VBoxContainer2/HBoxContainer/endereco/MarginContainer/VBoxContainer/HBoxContainer6/TextEdit_cidade.text


func _on_text_edit_estado_text_changed() -> void:
	info["dados"]["endereco"]["estado"] = $VBoxContainer2/HBoxContainer/endereco/MarginContainer/VBoxContainer/HBoxContainer7/TextEdit_estado.text


func _on_text_edit_nome_clinica_text_changed() -> void:
	info["dados"]["clinica"]["nome"] = $VBoxContainer2/HBoxContainer/clinica/MarginContainer/VBoxContainer/HBoxContainer/TextEdit_nome_clinica.text


func _on_text_edit_telefone_text_changed() -> void:
	info["dados"]["clinica"]["telefone"] = $VBoxContainer2/HBoxContainer/clinica/MarginContainer/VBoxContainer/HBoxContainer3/TextEdit_telefone.text


func _on_text_edit_instagram_text_changed() -> void:
	info["dados"]["clinica"]["instagram"] = $VBoxContainer2/HBoxContainer/clinica/MarginContainer/VBoxContainer/HBoxContainer4/TextEdit_instagram.text


func _on_text_edit_site_text_changed() -> void:
	info["dados"]["clinica"]["site"] = $VBoxContainer2/HBoxContainer/clinica/MarginContainer/VBoxContainer/HBoxContainer5/TextEdit_site.text


func _on_btn_carregar_logo_pressed() -> void:
	pass # Replace with function body.


func _on_text_edit_usuario_text_changed() -> void:
	info["usuario"] = $VBoxContainer2/HBoxContainer/acesso/MarginContainer/VBoxContainer/HBoxContainer5/TextEdit_usuario.text


func _on_text_edit_senha_text_changed() -> void:
	info["senha"] = $VBoxContainer2/HBoxContainer/acesso/MarginContainer/VBoxContainer/HBoxContainer3/TextEdit_senha.text


func _on_text_edit_senha_2_text_changed() -> void:
	info["senha2"] = $VBoxContainer2/HBoxContainer/acesso/MarginContainer/VBoxContainer/HBoxContainer4/TextEdit_senha2.text
