extends Control

# ============================================================
# CONFIGURAÇÃO
# ============================================================

@export var valores: Array[float] = [
	70.0,
	72.0,
	68.0,
	75.0,
	78.0,
	76.0,
	82.0
]

# Nomes que aparecem no eixo X
# Se deixar vazio, serão usados 1, 2, 3...
@export var etiquetas_x: Array[String] = [
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7"
]

@export var espessura_linha: float = 3.0
@export var raio_ponto: float = 5.0


# ============================================================
# MARGENS
# ============================================================

@export var margem_esquerda: float = 30.0
@export var margem_direita: float = 20.0
@export var margem_superior: float = 25.0
@export var margem_inferior: float = 40.0


# ============================================================
# GRADE
# ============================================================

@export var quantidade_grade: int = 5


# ============================================================
# CORES
# ============================================================

@export var cor_eixo := Color("#555555")
@export var cor_grade := Color("#303030")
@export var cor_linha := Color("#4CAF50")
@export var cor_ponto := Color("#FFFFFF")

@export var cor_texto := Color("#AAAAAA")
@export var cor_tooltip := Color("#202020")
@export var cor_tooltip_borda := Color("#4CAF50")


# ============================================================
# TOOLTIP
# ============================================================

var ponto_selecionado: int = -1
var mouse_pos: Vector2 = Vector2.ZERO

# Distância máxima do mouse para considerar que está
# sobre um ponto
@export var distancia_hover: float = 15.0


# ============================================================
# READY
# ============================================================

func _ready() -> void:

	mouse_filter = Control.MOUSE_FILTER_PASS

	queue_redraw()


# ============================================================
# PROCESS
# ============================================================

func _process(_delta: float) -> void:

	mouse_pos = get_local_mouse_position()

	verificar_ponto_hover()

	queue_redraw()


# ============================================================
# VERIFICA PONTO SOBRE O MOUSE
# ============================================================

func verificar_ponto_hover() -> void:

	ponto_selecionado = -1

	# Se não existe nenhum valor, não há ponto para verificar
	if valores.is_empty():
		return

	var pontos := calcular_pontos()

	for i in range(pontos.size()):

		var distancia := mouse_pos.distance_to(pontos[i])

		if distancia <= distancia_hover:

			ponto_selecionado = i

			return


# ============================================================
# CALCULA A ÁREA DO GRÁFICO
# ============================================================

func calcular_area() -> Rect2:

	return Rect2(
		margem_esquerda,
		margem_superior,
		size.x - margem_esquerda - margem_direita,
		size.y - margem_superior - margem_inferior
	)


# ============================================================
# CALCULA MÍNIMO E MÁXIMO
# ============================================================

func obter_limites() -> Vector2:

	# --------------------------------------------------------
	# Nenhum valor
	# --------------------------------------------------------
	#
	# Como não existe mínimo/máximo, usamos uma escala padrão.
	#
	# Isso permite que o gráfico seja desenhado mesmo vazio.
	#
	if valores.is_empty():

		return Vector2(
			0.0,
			100.0
		)

	# --------------------------------------------------------
	# Existem valores
	# --------------------------------------------------------

	var minimo: float = valores.min()
	var maximo: float = valores.max()

	# Se todos os valores forem iguais,
	# aumenta a escala para evitar divisão por zero.
	if minimo == maximo:

		minimo -= 1.0
		maximo += 1.0

	return Vector2(
		minimo,
		maximo
	)


# ============================================================
# CALCULA OS PONTOS
# ============================================================

func calcular_pontos() -> Array[Vector2]:

	var pontos: Array[Vector2] = []

	# --------------------------------------------------------
	# Nenhum valor
	# --------------------------------------------------------

	if valores.is_empty():

		return pontos


	var area := calcular_area()
	var limites := obter_limites()

	var minimo := limites.x
	var maximo := limites.y


	# ========================================================
	# APENAS 1 VALOR
	# ========================================================

	if valores.size() == 1:

		var porcentagem_y := inverse_lerp(
			minimo,
			maximo,
			valores[0]
		)

		# Inverte o Y
		porcentagem_y = 1.0 - porcentagem_y

		# Com apenas um valor,
		# coloca o ponto no centro do eixo X.
		var ponto := Vector2(
			(area.position.x + area.end.x) / 2.0,

			lerp(
				area.position.y,
				area.end.y,
				porcentagem_y
			)
		)

		pontos.append(ponto)

		return pontos


	# ========================================================
	# 2 OU MAIS VALORES
	# ========================================================

	for i in range(valores.size()):

		var porcentagem_x := float(i) / float(valores.size() - 1)

		var porcentagem_y := inverse_lerp(
			minimo,
			maximo,
			valores[i]
		)

		# Inverte o Y
		porcentagem_y = 1.0 - porcentagem_y

		var ponto := Vector2(

			lerp(
				area.position.x,
				area.end.x,
				porcentagem_x
			),

			lerp(
				area.position.y,
				area.end.y,
				porcentagem_y
			)
		)

		pontos.append(ponto)

	return pontos


# ============================================================
# DRAW
# ============================================================

func _draw() -> void:

	# --------------------------------------------------------
	# IMPORTANTE:
	# Não damos mais return quando existem menos de 2 valores.
	#
	# Assim o gráfico continua aparecendo mesmo vazio.
	# --------------------------------------------------------

	var area := calcular_area()
	var limites := obter_limites()

	var minimo := limites.x
	var maximo := limites.y

	var fonte := ThemeDB.fallback_font


	# ========================================================
	# EIXOS
	# ========================================================

	# Eixo Y
	draw_line(
		Vector2(
			area.position.x,
			area.position.y
		),

		Vector2(
			area.position.x,
			area.end.y
		),

		cor_eixo,
		2.0
	)


	# Eixo X
	draw_line(
		Vector2(
			area.position.x,
			area.end.y
		),

		Vector2(
			area.end.x,
			area.end.y
		),

		cor_eixo,
		2.0
	)


	# ========================================================
	# LINHAS DE GRADE + VALORES DO EIXO Y
	# ========================================================

	for i in range(quantidade_grade + 1):

		var porcentagem := float(i) / float(quantidade_grade)

		var y = lerp(
			area.position.y,
			area.end.y,
			porcentagem
		)


		# ----------------------------------------------------
		# Linha da grade
		# ----------------------------------------------------

		draw_line(
			Vector2(
				area.position.x,
				y
			),

			Vector2(
				area.end.x,
				y
			),

			cor_grade,
			1.0
		)


		# ----------------------------------------------------
		# Valor da régua
		# ----------------------------------------------------

		var valor = lerp(
			maximo,
			minimo,
			porcentagem
		)

		var texto := formatar_valor(valor)

		var tamanho := fonte.get_string_size(
			texto,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			12
		)

		draw_string(
			fonte,

			Vector2(
				area.position.x - tamanho.x - 8.0,
				y + 4.0
			),

			texto,

			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			12,

			cor_texto
		)


	# ========================================================
	# PONTOS
	# ========================================================

	var pontos := calcular_pontos()


	# ========================================================
	# LINHA
	# ========================================================

	# Se tiver apenas 1 ponto, não existe linha para desenhar.
	#
	# range(pontos.size() - 1)
	# também funcionaria, mas deixamos explícito.
	#
	if pontos.size() >= 2:

		for i in range(pontos.size() - 1):

			draw_line(
				pontos[i],
				pontos[i + 1],
				cor_linha,
				espessura_linha,
				true
			)


	# ========================================================
	# PONTOS
	# ========================================================

	for i in range(pontos.size()):

		var ponto := pontos[i]


		# ----------------------------------------------------
		# Ponto selecionado fica maior
		# ----------------------------------------------------

		if i == ponto_selecionado:

			draw_circle(
				ponto,
				raio_ponto + 5.0,
				Color(
					cor_linha,
					0.20
				)
			)

			draw_circle(
				ponto,
				raio_ponto + 2.0,
				cor_linha
			)

			draw_circle(
				ponto,
				raio_ponto - 1.0,
				cor_ponto
			)


		# ----------------------------------------------------
		# Ponto normal
		# ----------------------------------------------------

		else:

			draw_circle(
				ponto,
				raio_ponto,
				cor_linha
			)

			draw_circle(
				ponto,
				raio_ponto - 2.0,
				cor_ponto
			)


	# ========================================================
	# VALORES DO EIXO X
	# ========================================================

	for i in range(pontos.size()):

		var texto_x := obter_etiqueta_x(i)

		var tamanho_x := fonte.get_string_size(
			texto_x,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			12
		)

		draw_string(
			fonte,

			Vector2(
				pontos[i].x - tamanho_x.x / 2.0,
				area.end.y + 25.0
			),

			texto_x,

			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			12,

			cor_texto
		)


	# ========================================================
	# TOOLTIP
	# ========================================================

	if ponto_selecionado >= 0:

		desenhar_tooltip(
			pontos[ponto_selecionado],
			valores[ponto_selecionado]
		)


# ============================================================
# DESENHA TOOLTIP
# ============================================================

func desenhar_tooltip(
	ponto: Vector2,
	valor: float
) -> void:

	var fonte := ThemeDB.fallback_font

	var texto := formatar_valor(valor)

	var tamanho_texto := fonte.get_string_size(
		texto,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		14
	)

	var largura := tamanho_texto.x + 24.0
	var altura := 32.0


	# --------------------------------------------------------
	# Posicionamento
	# --------------------------------------------------------

	var posicao := ponto + Vector2(
		12.0,
		-45.0
	)


	# --------------------------------------------------------
	# Se sair pelo topo
	# --------------------------------------------------------

	if posicao.y < 5.0:

		posicao.y = ponto.y + 15.0


	# --------------------------------------------------------
	# Se sair pela direita
	# --------------------------------------------------------

	if posicao.x + largura > size.x:

		posicao.x = ponto.x - largura - 12.0


	# --------------------------------------------------------
	# Fundo
	# --------------------------------------------------------

	var caixa := Rect2(
		posicao,
		Vector2(
			largura,
			altura
		)
	)

	draw_style_box(
		criar_caixa_tooltip(),
		caixa
	)


	# --------------------------------------------------------
	# Texto
	# --------------------------------------------------------

	draw_string(
		fonte,

		Vector2(
			posicao.x + 12.0,
			posicao.y + 21.0
		),

		texto,

		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		14,

		Color.WHITE
	)


# ============================================================
# CAIXA DO TOOLTIP
# ============================================================

func criar_caixa_tooltip() -> StyleBoxFlat:

	var caixa := StyleBoxFlat.new()

	caixa.bg_color = cor_tooltip

	caixa.border_color = cor_tooltip_borda

	caixa.set_border_width_all(1)

	caixa.corner_radius_top_left = 6
	caixa.corner_radius_top_right = 6
	caixa.corner_radius_bottom_left = 6
	caixa.corner_radius_bottom_right = 6

	return caixa


# ============================================================
# FORMATA VALOR
# ============================================================

func formatar_valor(valor: float) -> String:

	if valor == floor(valor):

		return str(int(valor))

	return "%.1f" % valor


# ============================================================
# ETIQUETA DO EIXO X
# ============================================================

func obter_etiqueta_x(indice: int) -> String:

	if indice < etiquetas_x.size():

		return etiquetas_x[indice]

	return str(indice + 1)
