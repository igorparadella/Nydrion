extends Panel

var banco_de_dados = {
	"Taco": "res://data_base/Taco-4a-Edicao.csv"
}

@onready var lista_alimentos: VBoxContainer = $HBoxContainer/VBoxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/lista_alimentos
@onready var pesquisar_grupo: OptionButton = $HBoxContainer/VBoxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer2/pesquisar_grupo
@onready var campo_pesquisa: TextEdit = $HBoxContainer/VBoxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer2/TextEdit


func _ready() -> void:
	GlobalManager.atalhos["panel_novo_alimento"] = self
	visible = false
	carregar_grupos()
	pesquisar()


func carregar_grupos() -> void:
	pesquisar_grupo.clear()
	pesquisar_grupo.add_item("Todos")

	var caminho = banco_de_dados["Taco"]
	var arquivo = FileAccess.open(caminho, FileAccess.READ)

	if arquivo == null:
		push_error("Não foi possível abrir o CSV: " + caminho)
		return

	# O TACO possui 3 linhas de cabeçalho antes dos alimentos.
	arquivo.get_csv_line()
	arquivo.get_csv_line()
	arquivo.get_csv_line()

	var grupos: Array[String] = []

	while not arquivo.eof_reached():
		var linha = arquivo.get_csv_line()

		# Precisamos pelo menos de ID, nome e grupo.
		if linha.size() < 3:
			continue

		var id_texto := linha[0].strip_edges()
		var grupo := linha[2].strip_edges()

		# As linhas que contêm apenas o nome do grupo (ex.: "Cereais e derivados")
		# não possuem ID e, portanto, não são alimentos.
		if not id_texto.is_valid_int():
			continue

		if grupo == "":
			continue

		if grupo not in grupos:
			grupos.append(grupo)

	arquivo.close()

	for grupo in grupos:
		pesquisar_grupo.add_item(grupo)

var alvo

func escolher(d) -> void:
	visible = true
	alvo = d

func receber_alimento(d):
	if GlobalManager.paciente_aberto["plano_alimentar"]["refeicoes"][str(alvo["id"])].has(str(alvo["tipo"])):
		GlobalManager.paciente_aberto["plano_alimentar"]["refeicoes"][str(alvo["id"])][str(alvo["tipo"])].append(d)
	
		GlobalManager.salvar_paciente_aberto()
		
		$"..".limpar()
	visible = false

func _on_btn_fechar_pressed() -> void:
	visible = false


func pesquisar() -> void:
	var resultados = pesquisar2()

	for filho in lista_alimentos.get_children():
		filho.queue_free()

	var caminho_prefab = "res://prefab/plano_alimentar/alimento.res"
	
	
	for alimento in resultados:
		var dados = {"data": alimento}
		GlobalManager.adicionar_cena_como_filho(caminho_prefab, lista_alimentos, dados)


func pesquisar2() -> Array:
	var nome := campo_pesquisa.text.strip_edges()
	var grupo := pesquisar_grupo.get_item_text(pesquisar_grupo.selected).strip_edges()

	#print("Nome pesquisado: ", nome)
	#print("Grupo selecionado: ", grupo)

	var caminho = banco_de_dados["Taco"]
	var arquivo = FileAccess.open(caminho, FileAccess.READ)

	if arquivo == null:
		push_error("Não foi possível abrir o CSV: " + caminho)
		return []

	# Pula as 3 linhas de cabeçalho do TACO.
	arquivo.get_csv_line()
	arquivo.get_csv_line()
	arquivo.get_csv_line()

	var resultados: Array = []

	while not arquivo.eof_reached():
		var linha = arquivo.get_csv_line()

		# Precisamos das colunas até vitamina C.
		if linha.size() < 30:
			continue

		var id_texto := linha[0].strip_edges()
		var nome_alimento := linha[1].strip_edges()
		var grupo_alimento := linha[2].strip_edges()

		# Ignora cabeçalhos e linhas que não representam alimentos.
		if not id_texto.is_valid_int():
			continue

		if nome_alimento == "" or grupo_alimento == "":
			continue

		# Filtro por nome
		var nome_ok := true

		if nome != "":
			nome_ok = nome_alimento.to_lower().contains(nome.to_lower())

		# Filtro por grupo
		var grupo_ok := true

		if grupo != "" and grupo != "Todos":
			grupo_ok = grupo_alimento.to_lower() == grupo.to_lower()

		if not nome_ok or not grupo_ok:
			continue

		# =========================================================
		# MONTA O ALIMENTO COMPLETO
		# =========================================================

		var alimento = {
			"id": id_texto,
			"nome": nome_alimento,
			"grupo": grupo_alimento,

			"umidade_pct": linha[3],
			"energia_kcal": linha[4],
			"energia_kj": linha[5],
			"proteina_g": linha[6],
			"lipideos_g": linha[7],
			"colesterol_mg": linha[8],
			"carboidratos_g": linha[9],
			"fibra_alimentar_g": linha[10],
			"cinzas_g": linha[11],

			"calcio_mg": linha[12],
			"magnesio_mg": linha[13],
			"manganes_mg": linha[14],
			"fosforo_mg": linha[15],
			"ferro_mg": linha[16],
			"sodio_mg": linha[17],
			"potassio_mg": linha[18],
			"cobre_mg": linha[19],
			"zinco_mg": linha[20],

			"retinol_mcg": linha[21],
			"re_mcg": linha[22],
			"rae_mcg": linha[23],

			"tiamina_mg": linha[24],
			"riboflavina_mg": linha[25],
			"piridoxina_mg": linha[26],
			"niacina_mg": linha[27],
			"vitamina_c_mg": linha[28]
		}

		resultados.append(alimento)

	arquivo.close()

	#print("Resultados encontrados: ", resultados.size())

	return resultados

func _on_pesquisar_grupo_item_selected(index: int) -> void:
	pesquisar()


func _on_text_edit_text_changed() -> void:
	pesquisar()
