extends Control

@onready var escolha_de_alimento: Panel = $Panel2
@onready var criar_refeicao: Panel = $Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	escolha_de_alimento.visible = false
	criar_refeicao.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_fechar_escolha_de_alimento_pressed() -> void:
	escolha_de_alimento.visible = false


func _on_btn_criar_refeicao_pressed() -> void:
	criar_refeicao.visible = false


func _on_btn_abrir_escolha_alimento_pressed() -> void:
	escolha_de_alimento.visible = true


func _on_btn_abrir_nova_refeicao_pressed() -> void:
	criar_refeicao.visible = true


func _on_btn_voltar_pressed() -> void:
	GlobalManager.abrir_tela("paciente")
	pass # Replace with function body.
