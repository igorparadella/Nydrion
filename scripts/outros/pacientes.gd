extends Control

var pacientes
@onready var lista_pacientes: VBoxContainer = $MarginContainer/VBoxContainer/Panel2/MarginContainer/VBoxContainer/ScrollContainer/lista_pacientes



func _ready() -> void:
	atualizar()

func atualizar():
	pacientes = GlobalManager.carregar(str(GlobalManager.caminho,"pacientes.json"))
	
	for i in lista_pacientes.get_children():
		i.queue_free()
	
	
	var remover = []
	if not pacientes.is_empty():
		GlobalManager.pacientes = pacientes
		for i in GlobalManager.pacientes:
			var info = {}
			info['info'] = GlobalManager.carregar(str(GlobalManager.caminho,GlobalManager.pacientes[i]))
			if info['info'].is_empty():
				remover.append(i)
				continue
			GlobalManager.adicionar_cena_como_filho("res://prefab/pacientes/paciente.res",lista_pacientes,info)

		if not remover.is_empty():
			for i in remover:
				GlobalManager.pacientes.erase(i)
			
			GlobalManager.salvar(GlobalManager.pacientes,str(GlobalManager.caminho,"pacientes.json"))
	


func _on_btn_novo_paciente_pressed() -> void:
	GlobalManager.abrir_tela("anamnese")
	pass # Replace with function body.


func _on_text_edit_text_changed() -> void:
	pesquisar()


func _on_btn_pesquisar_pressed() -> void:
	pesquisar()

@onready var pesquisado: TextEdit = $MarginContainer/VBoxContainer/Panel/MarginContainer/HBoxContainer/TextEdit

func pesquisar():
	for i in lista_pacientes.get_children():
		i.queue_free()
	var a = GlobalManager.normalizar_texto(pesquisado.text)
	
	for i in GlobalManager.pacientes:
		var b = GlobalManager.normalizar_texto(i)
		if b.contains(a):
			var info = {}
			info['info'] = GlobalManager.carregar(str(GlobalManager.caminho,GlobalManager.pacientes[i]))
			
			GlobalManager.adicionar_cena_como_filho("res://prefab/pacientes/paciente.res",lista_pacientes,info)
	
	if pesquisado.text == "" or pesquisado.text == null:
		atualizar()
	
