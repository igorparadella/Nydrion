extends Panel
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var duracao_entrada: float = 0.5
@export var tempo_visivel: float = 10.0
@export var duracao_saida: float = 0.75

var posicao_final: Vector2
var posicao_inicial: Vector2
var tween: Tween
var titulo = ""
var msg = ""

func _ready() -> void:
	# Guarda a posição onde o popup deve ficar
	$MarginContainer/VBoxContainer/Label.text = titulo
	$MarginContainer/VBoxContainer/RichTextLabel.text = msg
	
	posicao_final = position
	
	# Começa acima da tela
	posicao_inicial = Vector2(
		posicao_final.x,
		-size.y
	)
	
	position = posicao_inicial
	
	# Esconde inicialmente
	visible = false
	mostrar_popup()

func mostrar_popup() -> void:
	# Se já estiver aparecendo, reinicia
	if tween and tween.is_valid():
		tween.kill()
	
	visible = true
	
	audio_stream_player.play()
	
	# Garante que começa no topo
	position = posicao_inicial
	
	tween = create_tween()
	
	# DESCENDO
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(
		self,
		"position",
		posicao_final,
		duracao_entrada
	)
	
	# Fica visível
	tween.tween_interval(tempo_visivel)
	
	# SUBINDO
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(
		self,
		"position",
		posicao_inicial,
		duracao_saida
	)
	
	# Esconde quando terminar
	tween.tween_callback(func():
		visible = false
	)


func _on_btn_fechar_pressed() -> void:
	fechar_popup()


func fechar_popup() -> void:
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN)
	
	tween.tween_property(
		self,
		"position",
		posicao_inicial,
		duracao_saida
	)
	
	tween.tween_callback(func():
		queue_free()
	)
