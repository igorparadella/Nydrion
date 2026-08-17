extends Node


func selecionar_arquivo() -> String:
	# Cria o FileDialog
	var file_dialog := FileDialog.new()

	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.use_native_dialog = true

	add_child(file_dialog)

	# Abre o seletor
	file_dialog.popup_centered_ratio(0.7)

	# Espera o usuário escolher um arquivo
	var caminho_original: String = await file_dialog.file_selected

	# Remove o FileDialog
	file_dialog.queue_free()

	if caminho_original.is_empty():
		return ""


	# ==========================================
	# CRIA A PASTA RECURSOS
	# ==========================================

	var pasta_recursos := "user://recursos"

	if not DirAccess.dir_exists_absolute(pasta_recursos):
		var erro := DirAccess.make_dir_absolute(pasta_recursos)

		if erro != OK:
			push_error("Não foi possível criar a pasta: " + pasta_recursos)
			return ""


	# ==========================================
	# DEFINE O NOME DO ARQUIVO
	# ==========================================

	var nome_arquivo := caminho_original.get_file()
	var nome_base := nome_arquivo.get_basename()
	var extensao := nome_arquivo.get_extension()

	var caminho_destino := pasta_recursos + "/" + nome_arquivo

	var contador := 1

	# Se já existir, cria:
	# arquivo_1.png
	# arquivo_2.png
	# arquivo_3.png
	# etc.
	while FileAccess.file_exists(caminho_destino):
		nome_arquivo = nome_base + "_" + str(contador)

		if extensao != "":
			nome_arquivo += "." + extensao

		caminho_destino = pasta_recursos + "/" + nome_arquivo

		contador += 1


	# ==========================================
	# ABRE O ARQUIVO ORIGINAL
	# ==========================================

	var arquivo_original := FileAccess.open(
		caminho_original,
		FileAccess.READ
	)

	if arquivo_original == null:
		push_error(
			"Não foi possível abrir o arquivo: " +
			caminho_original
		)
		return ""


	# Lê os dados
	var dados := arquivo_original.get_buffer(
		arquivo_original.get_length()
	)

	arquivo_original.close()


	# ==========================================
	# CRIA O ARQUIVO DE DESTINO
	# ==========================================

	var arquivo_destino := FileAccess.open(
		caminho_destino,
		FileAccess.WRITE
	)

	if arquivo_destino == null:
		push_error(
			"Não foi possível criar o arquivo: " +
			caminho_destino
		)
		return ""


	# Copia os dados
	arquivo_destino.store_buffer(dados)
	arquivo_destino.close()


	# ==========================================
	# RESULTADO
	# ==========================================

	return caminho_destino
