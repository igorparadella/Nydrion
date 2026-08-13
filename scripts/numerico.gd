extends HBoxContainer

@export var numero_quebrado: bool = false
@export var negativo: bool = false
@export var valor_minimo: float = -9999.0
@export var valor_maximo: float = 9999.0
@export var valor_inicial: float = 0.0
@export var passo: float = 1.0

var valor: float = 0.0

var printar = false

func _ready() -> void:
	valor = valor_inicial

	# Se não permitir números negativos, o mínimo nunca será menor que 0.
	if not negativo:
		valor_minimo = max(valor_minimo, 0.0)

	# Se não permitir números quebrados, o passo deve ser inteiro.
	if not numero_quebrado:
		valor = round(valor)
		passo = 1.0

	valor = clamp(valor, valor_minimo, valor_maximo)

	atualizar_valor()


func _on_mais_pressed() -> void:
	valor += passo

	if not numero_quebrado:
		valor = round(valor)

	valor = clamp(valor, valor_minimo, valor_maximo)

	atualizar_valor()


func _on_menos_pressed() -> void:
	valor -= passo

	if not numero_quebrado:
		valor = round(valor)

	valor = clamp(valor, valor_minimo, valor_maximo)

	atualizar_valor()


func atualizar_valor() -> void:
	if printar: print("Valor atual: ", valor)

	# Se você tiver um Label para mostrar o valor,
	# coloque o caminho dele aqui.
	#
	# Exemplo:
	# $Label.text = str(valor)
