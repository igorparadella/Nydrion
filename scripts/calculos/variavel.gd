extends HBoxContainer

var variavel
var destino


func _ready() -> void:
	$Label.text = str(variavel)


func _on_line_edit_text_changed(new_text: String) -> void:
	var texto := new_text.strip_edges()
	var texto_filtrado := ""
	var tem_separador := false
	
	# Aceita apenas números, "." e ","
	for caractere in texto:
		if caractere >= "0" and caractere <= "9":
			texto_filtrado += caractere
		
		elif caractere == "." or caractere == ",":
			# Permite apenas um separador decimal
			if not tem_separador:
				texto_filtrado += caractere
				tem_separador = true
	
	# Se o texto foi alterado, atualiza o LineEdit
	if texto_filtrado != texto:
		$LineEdit.text = texto_filtrado
		$LineEdit.caret_column = texto_filtrado.length()
	
	# Se estiver vazio, não altera o valor
	if texto_filtrado.is_empty():
		return
	
	# Vírgula vira ponto
	texto_filtrado = texto_filtrado.replace(",", ".")
	
	# Converte para float
	var valor := float(texto_filtrado)
	
	destino.formula["variaveis"][variavel] = valor
