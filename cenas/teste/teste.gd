extends Control

# ============================================================
# CONFIGURAÇÃO DA IMAGEM
# ============================================================

const LARGURA := 1240
const ALTURA := 1754


# ============================================================
# REFERÊNCIAS
# ============================================================

var viewport: SubViewport
var documento: Control

var imagem_pendente: Image


# ============================================================
# READY
# ============================================================

func _ready() -> void:
	criar_documento()

	# Espera o documento ser renderizado
	await RenderingServer.frame_post_draw

	salvar_imagem()


# ============================================================
# CRIA O SUBVIEWPORT
# ============================================================

func criar_documento() -> void:

	viewport = SubViewport.new()

	viewport.size = Vector2i(LARGURA, ALTURA)
	viewport.transparent_bg = false

	# Renderiza continuamente enquanto estamos preparando
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS

	add_child(viewport)


	# ========================================================
	# CONTROL DO DOCUMENTO
	# ========================================================

	documento = Control.new()

	documento.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	viewport.add_child(documento)


	# ========================================================
	# SCRIPT DE DESENHO
	# ========================================================

	documento.set_script(
		preload("res://cenas/teste/documento_desenho.gd")
	)


# ============================================================
# ABRIR "SALVAR COMO"
# ============================================================

func salvar_imagem() -> void:

	# IMPORTANTE:
	# Captura o SubViewport e não o viewport principal.

	var imagem := viewport.get_texture().get_image()

	if imagem == null:
		push_error("Não foi possível capturar o documento.")
		return

	# Guarda a imagem até o usuário escolher onde salvar
	imagem_pendente = imagem


	# ========================================================
	# FILTRO PNG
	# ========================================================

	var filtros := PackedStringArray([
		"*.png;Imagem PNG;image/png"
	])


	# ========================================================
	# ABRE O DIÁLOGO NATIVO
	# ========================================================

	var erro := DisplayServer.file_dialog_show(
		"Salvar plano alimentar",

		# Pasta inicial
		OS.get_environment("HOME") + "/Downloads",

		# Nome inicial
		"plano_alimentar.png",

		# Mostrar arquivos ocultos
		false,

		# Modo
		DisplayServer.FILE_DIALOG_MODE_SAVE_FILE,

		# Filtros
		filtros,

		# Callback
		Callable(self, "_arquivo_escolhido")
	)


	if erro != OK:
		push_error(
			"Não foi possível abrir o diálogo de arquivos. Erro: "
			+ str(erro)
		)


# ============================================================
# CALLBACK DO DIÁLOGO
# ============================================================

func _arquivo_escolhido(
	status: bool,
	caminhos: PackedStringArray,
	filtro: int
) -> void:

	#print("Callback executado!")
#
	#print("Status: ", status)
	#print("Caminhos: ", caminhos)
	#print("Filtro: ", filtro)


	# Usuário cancelou
	if not status:
		#print("Usuário cancelou o salvamento.")
		return


	# Nenhum arquivo selecionado
	if caminhos.is_empty():
		push_error("Nenhum caminho foi selecionado.")
		return


	# Pega o primeiro caminho
	var caminho := caminhos[0]

	print("Salvando em: ", caminho)


	# ========================================================
	# GARANTE .PNG
	# ========================================================

	if not caminho.to_lower().ends_with(".png"):
		caminho += ".png"


	# ========================================================
	# SALVA A IMAGEM
	# ========================================================

	if imagem_pendente == null:
		push_error("A imagem pendente é nula.")
		return


	var erro := imagem_pendente.save_png(caminho)


	if erro == OK:

		print("================================")
		print("IMAGEM SALVA COM SUCESSO!")
		print("Caminho: ", caminho)
		print("================================")

	else:

		push_error(
			"Erro ao salvar PNG. Código: "
			+ str(erro)
		)
