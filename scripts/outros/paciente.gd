extends Panel
@onready var label_nome: Label = $MarginContainer/HBoxContainer/VBoxContainer/Label_nome
@onready var label_2_sexo: Label = $MarginContainer/HBoxContainer/VBoxContainer/Label2_sexo
@onready var label_telefone: Label = $MarginContainer/HBoxContainer/VBoxContainer2/Label_telefone
@onready var label_2_email: Label = $MarginContainer/HBoxContainer/VBoxContainer2/Label2_email
@onready var label_2_ultima_consulta: Label = $MarginContainer/HBoxContainer/VBoxContainer3/Label2_ultima_consulta
@onready var label_2_proxima_consulta: Label = $MarginContainer/HBoxContainer/VBoxContainer4/Label2_proxima_consulta

var info = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(info)
	
	if not info.is_empty() and info != {}:
		if info['dados_pessoais'].has("nome"):
			label_nome.text = info['dados_pessoais']["nome"]
			
		if info["dados_pessoais"].has("nascimento"):
			var data_nascimento: String = info["dados_pessoais"]["nascimento"]

			# Separa dia, mês e ano
			var partes = data_nascimento.split("/")

			if partes.size() == 3:
				var dia: int = int(partes[0])
				var mes: int = int(partes[1])
				var ano: int = int(partes[2])

				# Data atual
				var data_atual = Time.get_date_dict_from_system()

				var idade: int = data_atual["year"] - ano

				# Ainda não fez aniversário este ano
				if data_atual["month"] < mes or (
					data_atual["month"] == mes and data_atual["day"] < dia
				):
					idade -= 1

				label_2_sexo.text = str(idade) + " anos"
			
		else:
			label_2_sexo.text = ""
		
		if info['dados_pessoais'].has("sexo"):
			var sexo = int(info['dados_pessoais']["sexo"])
			
			if sexo == 0:
				label_2_sexo.text += " - masculino"
			
			elif sexo == 1:
				label_2_sexo.text += " - feminino"
			else :
				label_2_sexo.text += " - não informado"
	
		if info['dados_pessoais'].has("telefone"):
			label_telefone.text = info['dados_pessoais']["telefone"]
			
		if info['dados_pessoais'].has("e-mail"):
			label_2_email.text = info['dados_pessoais']["e-mail"]
			
		if info['historico'].has("ultima_consulta"):
			label_2_ultima_consulta.text = info['historico']["ultima_consulta"]
		else:
			label_2_ultima_consulta.text = "Não teve uma consulta ainda"
		
		
		if info['historico'].has("proxima_consulta"):
			label_2_proxima_consulta.text = info['historico']["proxima_consulta"]
		else:
			label_2_proxima_consulta.text = "Nenhuma consulta marcada"
			




func _on_button_pressed() -> void:
	GlobalManager.paciente_aberto = info
	GlobalManager.abrir_tela("paciente")
