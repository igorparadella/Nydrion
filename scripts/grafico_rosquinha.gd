extends Control

# ============================================================
# DADOS
# ============================================================

@export var valores: Array[float] = [
	40.0,
	30.0,
	20.0,
	10.0
]

@export var nomes: Array[String] = [
	"Carboidratos",
	"Proteínas",
	"Gorduras",
	"Fibras"
]

# ============================================================
# CONFIGURAÇÃO
# ============================================================

@export var espessura: float = 70.0

@export var tamanho_centro: float = 70.0

@export var margem: float = 20.0

# Cores das partes
@export var cores: Array[Color] = [
	Color("#4CAF50"),
	Color("#2196F3"),
	Color("#FF9800"),
	Color("#9C27B0")
]

# ============================================================
# READY
# ============================================================

func _ready() -> void:
	queue_redraw()


# ============================================================
# DRAW
# ============================================================

func _draw() -> void:

	if valores.is_empty():
		return

	var total := 0.0

	for valor in valores:
		total += valor

	if total <= 0:
		return

	# --------------------------------------------------------
	# CENTRO DA ROSQUINHA
	# --------------------------------------------------------

	var centro := size / 2.0

	# Raio externo
	var raio = min(size.x, size.y) / 2.0 - margem

	# --------------------------------------------------------
	# DESENHA AS FATIAS
	# --------------------------------------------------------

	var angulo_inicio := -PI / 2.0

	for i in range(valores.size()):

		var porcentagem := valores[i] / total

		var angulo_tamanho := porcentagem * TAU

		var angulo_fim := angulo_inicio + angulo_tamanho

		var cor := cores[i % cores.size()]

		desenhar_fatia(
			centro,
			raio,
			espessura,
			angulo_inicio,
			angulo_fim,
			cor
		)

		angulo_inicio = angulo_fim

	# --------------------------------------------------------
	# CENTRO
	# --------------------------------------------------------

	draw_circle(
		centro,
		raio - espessura,
		Color("#1E1E1E")
	)

	# --------------------------------------------------------
	# TEXTO CENTRAL
	# --------------------------------------------------------

	var fonte := ThemeDB.fallback_font

	var texto := str(int(total))

	var tamanho_texto := 22

	var tamanho := fonte.get_string_size(
		texto,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		tamanho_texto
	)

	draw_string(
		fonte,
		centro - Vector2(tamanho.x / 2.0, -tamanho.y / 2.0),
		texto,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		tamanho_texto,
		Color.WHITE
	)


# ============================================================
# DESENHA UMA FATIA
# ============================================================

func desenhar_fatia(
	centro: Vector2,
	raio: float,
	espessura_fatia: float,
	angulo_inicio: float,
	angulo_fim: float,
	cor: Color
) -> void:

	var raio_interno := raio - espessura_fatia

	var pontos: PackedVector2Array = []

	var quantidade = max(
		8,
		int(abs(angulo_fim - angulo_inicio) * 30.0)
	)

	# --------------------------------------------------------
	# ARCO EXTERNO
	# --------------------------------------------------------

	for i in range(quantidade + 1):

		var t := float(i) / float(quantidade)

		var angulo = lerp(
			angulo_inicio,
			angulo_fim,
			t
		)

		pontos.append(
			centro + Vector2(
				cos(angulo),
				sin(angulo)
			) * raio
		)

	# --------------------------------------------------------
	# ARCO INTERNO
	# --------------------------------------------------------

	for i in range(quantidade, -1, -1):

		var t := float(i) / float(quantidade)

		var angulo = lerp(
			angulo_inicio,
			angulo_fim,
			t
		)

		pontos.append(
			centro + Vector2(
				cos(angulo),
				sin(angulo)
			) * raio_interno
		)

	# --------------------------------------------------------
	# DESENHA POLÍGONO
	# --------------------------------------------------------

	draw_colored_polygon(
		pontos,
		cor
	)
