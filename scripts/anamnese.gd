extends Control

@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var manual: HBoxContainer = $MarginContainer/manual
@onready var doc: HBoxContainer = $MarginContainer/doc

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	h_box_container.visible = true
	manual.visible = false
	doc.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_manual_pressed() -> void:
	h_box_container.visible = false
	manual.visible = true
	doc.visible = false

func _on_btn_doc_pressed() -> void:
	h_box_container.visible = false
	manual.visible = false
	doc.visible = true


func _on_btn_prev_pressed() -> void:
	manual.etapa = 0
	h_box_container.visible = true
	manual.visible = false
	doc.visible = false
