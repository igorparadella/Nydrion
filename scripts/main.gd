extends Control

@onready var tela: Control = $HBoxContainer/Control


var telas = {
	"visao_geral": "res://cenas/visao_geral.tscn",
	"agenda": "res://cenas/agenda.tscn",
	"pacientes": "res://cenas/pacientes.tscn",
	"paciente": "res://cenas/paciente.tscn",
	"calculos": "res://cenas/calculos.tscn",
	"avaliacao_atual": "res://cenas/avaliacao_atual.tscn",
	"plano_alimentar": "res://cenas/plano_alimentar.tscn",
	"novo_paciente": "res://cenas/novo_paciente.tscn",
	"anamnese": "res://cenas/anamnese.tscn",
}


var ultima_tela = null
var tela_atual = null

func _ready() -> void:
	GlobalManager.atalhos["main"] = self
	GlobalManager.caminho = str("user://usuarios/",GlobalManager.info["usuario"],"/")
	GlobalManager.config = GlobalManager.carregar(str(GlobalManager.caminho,"config.json"))
	if GlobalManager.config == {} or GlobalManager.config.is_empty():
		GlobalManager.criar_config()
	
	#print(GlobalManager.caminho,"config.json")
	
	abrir_tela("visao_geral")
	
	for i in GlobalManager.config['agenda']:
		if data_valida(GlobalManager.config['agenda'][i]["consulta"]["dia"]) == false:
			GlobalManager.config['agenda'].erase(i)
			GlobalManager.salvar_config()


func data_valida(data_a: String) -> bool:
	var partes = data_a.replace("/", "_").split("_")
	
	if partes.size() != 3:
		return false
	
	var dia = int(partes[0])
	var mes = int(partes[1])
	var ano = int(partes[2])
	
	var agora = Time.get_datetime_dict_from_system()
	
	var data_a_num = ano * 10000 + mes * 100 + dia
	var data_b_num = agora["year"] * 10000 + agora["month"] * 100 + agora["day"]
	
	# Retorna false se A for antes de B
	# Retorna true se A for igual ou depois de B
	return data_a_num >= data_b_num



func abrir_tela(nome_tela: String) -> void:
	# Verifica se a tela existe
	if not telas.has(nome_tela):
		printerr("Tela não encontrada: ", nome_tela)
		return


	if tela_atual != null and tela_atual == ultima_tela: return
	
	# Remove a tela atual
	for filho in tela.get_children():
		filho.queue_free()



	tela_atual = nome_tela
	# Pega o caminho da cena
	var caminho: String = telas[nome_tela]

	# Carrega a cena
	var cena: PackedScene = load(caminho)

	if cena == null:
		printerr("Não foi possível carregar a cena: ", caminho)
		return

	# Instancia a cena
	var nova_tela: Node = cena.instantiate()

	# Adiciona dentro do Control
	tela.add_child(nova_tela)

	# Se for um Control, ocupa todo o espaço disponível
	if nova_tela is Control:
		nova_tela.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


func _on_btn_visao_geral_pressed() -> void:
	abrir_tela("visao_geral")
	



func _on_btn_pacientes_pressed() -> void:
	abrir_tela("pacientes")


func _on_btn_agenda_pressed() -> void:
	abrir_tela("agenda")


func _on_btn_calculos_pressed() -> void:
	abrir_tela("calculos")


func _on_button_3_pressed() -> void:
	abrir_pasta(GlobalManager.caminho)
	pass # Replace with function body.

func abrir_pasta(caminho: String) -> void:
	var caminho_real := ProjectSettings.globalize_path(caminho)

	if not DirAccess.dir_exists_absolute(caminho_real):
		push_error("Pasta não existe: " + caminho_real)
		return

	OS.shell_open(caminho_real)
