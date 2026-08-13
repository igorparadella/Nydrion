extends Control


func _ready() -> void:
	custom_minimum_size = Vector2(1240, 1754)

	queue_redraw()


func _draw() -> void:

	# ========================================================
	# FUNDO
	# ========================================================

	draw_rect(
		Rect2(0, 0, 1240, 1754),
		Color.WHITE
	)


	# ========================================================
	# TÍTULO
	# ========================================================

	draw_string(
		ThemeDB.fallback_font,
		Vector2(100, 100),
		"PLANO ALIMENTAR",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		48,
		Color.BLACK
	)


	# ========================================================
	# INFORMAÇÕES DO PACIENTE
	# ========================================================

	draw_string(
		ThemeDB.fallback_font,
		Vector2(100, 180),
		"Paciente: João Silva",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		28,
		Color.BLACK
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(100, 225),
		"Data: 11/08/2026",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		28,
		Color.BLACK
	)


	# ========================================================
	# LINHA
	# ========================================================

	draw_line(
		Vector2(100, 270),
		Vector2(1140, 270),
		Color.BLACK,
		2
	)


	# ========================================================
	# CAFÉ DA MANHÃ
	# ========================================================

	draw_string(
		ThemeDB.fallback_font,
		Vector2(100, 350),
		"CAFÉ DA MANHÃ",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		32,
		Color.BLACK
	)


	# Alimentos

	draw_string(
		ThemeDB.fallback_font,
		Vector2(130, 410),
		"Pão integral",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		26,
		Color.BLACK
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(900, 410),
		"2 fatias",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		26,
		Color.BLACK
	)


	draw_string(
		ThemeDB.fallback_font,
		Vector2(130, 460),
		"Ovo",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		26,
		Color.BLACK
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(900, 460),
		"2 unidades",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		26,
		Color.BLACK
	)


	# ========================================================
	# ALMOÇO
	# ========================================================

	draw_string(
		ThemeDB.fallback_font,
		Vector2(100, 570),
		"ALMOÇO",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		32,
		Color.BLACK
	)


	draw_string(
		ThemeDB.fallback_font,
		Vector2(130, 630),
		"Arroz",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		26,
		Color.BLACK
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(900, 630),
		"100 g",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		26,
		Color.BLACK
	)


	draw_string(
		ThemeDB.fallback_font,
		Vector2(130, 680),
		"Feijão",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		26,
		Color.BLACK
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(900, 680),
		"80 g",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		26,
		Color.BLACK
	)


	draw_string(
		ThemeDB.fallback_font,
		Vector2(130, 730),
		"Frango grelhado",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		26,
		Color.BLACK
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(900, 730),
		"120 g",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		26,
		Color.BLACK
	)


	# ========================================================
	# RODAPÉ
	# ========================================================

	draw_line(
		Vector2(100, 1650),
		Vector2(1140, 1650),
		Color.BLACK,
		2
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(100, 1700),
		"NutriPro",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		24,
		Color.BLACK
	)
