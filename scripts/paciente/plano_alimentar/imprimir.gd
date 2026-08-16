extends Control


@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var folha: Control = $SubViewportContainer/SubViewport/Control


const TAMANHO_FOLHA := Vector2i(2480, 3508)

var imagem_para_salvar: Image


func _ready() -> void:
	# Define o tamanho real da folha
	sub_viewport.size = TAMANHO_FOLHA

	# Mantém o viewport sempre sendo renderizado
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS

	# A folha ocupa todo o SubViewport
	folha.position = Vector2.ZERO
	folha.size = Vector2(TAMANHO_FOLHA)


	# Garante o tamanho completo
	sub_viewport.size = TAMANHO_FOLHA

	folha.position = Vector2.ZERO
	folha.size = Vector2(TAMANHO_FOLHA)

	# Espera a folha terminar de renderizar
	await get_tree().process_frame
	await RenderingServer.frame_post_draw

	# Captura o SubViewport inteiro
	var imagem := sub_viewport.get_texture().get_image()

	if imagem == null:
		printerr("Erro: não conseguiu capturar a folha.")
		return

	#print("Imagem capturada: ", imagem.get_size())

	# Guarda a imagem
	imagem_para_salvar = imagem

	# Abre o diálogo nativo do Linux
	abrir_dialogo_salvar()


func abrir_dialogo_salvar() -> void:
	var caminho_inicial := OS.get_environment("HOME") + "/plano_alimentar.png"

	var argumentos := [
		"--file-selection",
		"--save",
		"--confirm-overwrite",
		"--title=Salvar plano alimentar",
		"--filename=" + caminho_inicial,
		"--file-filter=Imagem PNG | *.png"
	]

	# Executa o Zenity e espera o usuário escolher
	var saida := []

	var resultado := OS.execute(
		"zenity",
		argumentos,
		saida,
		true
	)

	# Usuário cancelou
	if resultado != 0:
		printerr("Salvamento cancelado.")
		imagem_para_salvar = null
		return

	if saida.is_empty():
		printerr("Nenhum caminho foi escolhido.")
		imagem_para_salvar = null
		return

	var caminho := str(saida[0]).strip_edges()

	if caminho.is_empty():
		printerr("Caminho vazio.")
		imagem_para_salvar = null
		return

	# Garante que termine com .png
	if not caminho.to_lower().ends_with(".png"):
		caminho += ".png"

	# Salva a imagem
	var erro := imagem_para_salvar.save_png(caminho)

	if erro == OK:
		#print("================================")
		#print("Imagem salva com sucesso!")
		#print("Caminho: ", caminho)
		#print("Tamanho: ", imagem_para_salvar.get_size())
		#print("================================")
		pass
	else:
		printerr("Erro ao salvar imagem: ", erro)

	imagem_para_salvar = null
