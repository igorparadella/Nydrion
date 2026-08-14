extends Control
class_name NutritionRadarChart

# ============================================================
# RADAR NUTRICIONAL - NUTRIPRO
# ============================================================

@export var nutrientes: Dictionary = {
	"Proteínas": 80.0,
	"Carboidratos": 65.0,
	"Gorduras": 75.0,
	"Fibras": 55.0,
	"Hidratação": 90.0,
	"Micronutrientes": 70.0
}

# 100 = 100% da meta
@export var valor_maximo: float = 100.0


# ============================================================
# TAMANHO
# ============================================================

@export_category("Tamanho")

@export var raio: float = 180.0

@export var linhas_nivel: int = 5

@export var distancia_texto: float = 40.0


# ============================================================
# LINHAS
# ============================================================

@export_category("Linhas")

@export var espessura_grade: float = 1.0

@export var espessura_eixo: float = 1.5

@export var espessura_grafico: float = 3.0


# ============================================================
# PONTOS
# ============================================================

@export_category("Pontos")

@export var tamanho_ponto: float = 5.0


# ============================================================
# CORES
# ============================================================

@export_category("Cores")

@export var cor_fundo: Color = Color(
	0.03,
	0.07,
	0.05,
	0.8
)

@export var cor_grade: Color = Color(
	0.35,
	0.45,
	0.40,
	0.6
)

@export var cor_eixo: Color = Color(
	0.45,
	0.55,
	0.50,
	0.8
)

@export var cor_grafico: Color = Color(
	0.20,
	0.75,
	0.45,
	1.0
)

@export var cor_preenchimento: Color = Color(
	0.20,
	0.75,
	0.45,
	0.20
)

@export var cor_ponto: Color = Color(
	0.45,
	1.0,
	0.65,
	1.0
)

@export var cor_texto: Color = Color.WHITE


# ============================================================
# TEXTO
# ============================================================

@export_category("Texto")

@export var tamanho_texto: int = 16


var fonte: Font


# ============================================================
# READY
# ============================================================

func _ready() -> void:

	fonte = ThemeDB.fallback_font

	queue_redraw()


# ============================================================
# DRAW
# ============================================================

func _draw() -> void:

	if nutrientes.is_empty():
		return

	var centro := size / 2.0

	var quantidade := nutrientes.size()


	# Fundo

	draw_circle(
		centro,
		raio,
		cor_fundo
	)


	# Grade

	desenhar_grade(
		centro,
		quantidade
	)


	# Eixos

	desenhar_eixos(
		centro,
		quantidade
	)


	# Dados

	desenhar_dados(
		centro,
		quantidade
	)


	# Nomes

	desenhar_nomes(
		centro,
		quantidade
	)


# ============================================================
# GRADE
# ============================================================

func desenhar_grade(
	centro: Vector2,
	quantidade: int
) -> void:

	for nivel in range(
		1,
		linhas_nivel + 1
	):

		var porcentagem := (
			float(nivel) /
			float(linhas_nivel)
		)

		var pontos := PackedVector2Array()


		for i in range(quantidade):

			var angulo := calcular_angulo(
				i,
				quantidade
			)

			var ponto := (
				centro +
				Vector2.from_angle(angulo) *
				raio *
				porcentagem
			)

			pontos.append(ponto)


		# Fecha o polígono

		pontos.append(
			pontos[0]
		)


		for i in range(
			pontos.size() - 1
		):

			draw_line(
				pontos[i],
				pontos[i + 1],
				cor_grade,
				espessura_grade
			)


# ============================================================
# EIXOS
# ============================================================

func desenhar_eixos(
	centro: Vector2,
	quantidade: int
) -> void:

	for i in range(quantidade):

		var angulo := calcular_angulo(
			i,
			quantidade
		)

		var ponto := (
			centro +
			Vector2.from_angle(angulo) *
			raio
		)


		draw_line(
			centro,
			ponto,
			cor_eixo,
			espessura_eixo
		)


# ============================================================
# DADOS NUTRICIONAIS
# ============================================================

func desenhar_dados(
	centro: Vector2,
	quantidade: int
) -> void:

	var pontos := PackedVector2Array()

	var nomes := nutrientes.keys()


	for i in range(quantidade):

		var nome := str(
			nomes[i]
		)

		var valor := float(
			nutrientes[nome]
		)


		valor = clamp(
			valor,
			0.0,
			valor_maximo
		)


		var porcentagem := (
			valor /
			valor_maximo
		)


		var angulo := calcular_angulo(
			i,
			quantidade
		)


		var ponto := (
			centro +
			Vector2.from_angle(angulo) *
			raio *
			porcentagem
		)


		pontos.append(ponto)


	if pontos.size() < 3:
		return


	# ========================================================
	# ÁREA
	# ========================================================

	var cores := PackedColorArray()


	for i in range(
		pontos.size()
	):

		cores.append(
			cor_preenchimento
		)


	draw_polygon(
		pontos,
		cores
	)


	# ========================================================
	# LINHAS
	# ========================================================

	for i in range(
		pontos.size()
	):

		var proximo := (
			i + 1
		) % pontos.size()


		draw_line(
			pontos[i],
			pontos[proximo],
			cor_grafico,
			espessura_grafico
		)


	# ========================================================
	# PONTOS
	# ========================================================

	for ponto in pontos:

		draw_circle(
			ponto,
			tamanho_ponto,
			cor_ponto
		)


# ============================================================
# NOMES
# ============================================================

func desenhar_nomes(
	centro: Vector2,
	quantidade: int
) -> void:

	var nomes := nutrientes.keys()


	for i in range(quantidade):

		var nome := str(
			nomes[i]
		)


		var angulo := calcular_angulo(
			i,
			quantidade
		)


		var posicao := (
			centro +
			Vector2.from_angle(angulo) *
			(raio + distancia_texto)
		)


		var tamanho := fonte.get_string_size(
			nome,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			tamanho_texto
		)


		posicao.x -= (
			tamanho.x / 2.0
		)

		posicao.y += (
			tamanho.y / 2.0
		)


		draw_string(
			fonte,
			posicao,
			nome,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			tamanho_texto,
			cor_texto
		)


# ============================================================
# ÂNGULO
# ============================================================

func calcular_angulo(
	indice: int,
	quantidade: int
) -> float:

	var angulo_inicial := (
		-PI / 2.0
	)


	return (
		angulo_inicial +
		(
			TAU /
			float(quantidade)
		) *
		indice
	)


# ============================================================
# DEFINIR NUTRIENTES
# ============================================================

func definir_nutrientes(
	novos_nutrientes: Dictionary
) -> void:

	nutrientes = (
		novos_nutrientes.duplicate()
	)

	queue_redraw()


# ============================================================
# ALTERAR UM NUTRIENTE
# ============================================================

func definir_nutriente(
	nome: String,
	valor: float
) -> void:

	nutrientes[nome] = clamp(
		valor,
		0.0,
		valor_maximo
	)

	queue_redraw()


# ============================================================
# PEGAR VALOR
# ============================================================

func pegar_nutriente(
	nome: String
) -> float:

	if not nutrientes.has(nome):
		return 0.0

	return float(
		nutrientes[nome]
	)


# ============================================================
# LIMPAR
# ============================================================

func limpar() -> void:

	nutrientes.clear()

	queue_redraw()
