extends Panel

@onready var gramas: TextEdit = $MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/gramas

@onready var nome: Label = $MarginContainer/VBoxContainer/Label
@onready var descricao: RichTextLabel = $MarginContainer/VBoxContainer/RichTextLabel


# ============================================================
# CONFIGURAÇÃO
# ============================================================

var gramas_atual: float = 100.0

# Guarda os dados originais, sempre referentes a 100 g.
var alimento_data: Dictionary = {}


# ============================================================
# READY
# ============================================================

func _ready() -> void:
	GlobalManager.atalhos["Panel2_descricao_alimento"] = self
	
	# Valor inicial
	gramas.text = str(gramas_atual)


# ============================================================
# MOSTRAR ALIMENTO
# ============================================================

func mostar(data: Dictionary) -> void:
	# Guarda os dados originais.
	# Esses valores representam sempre 100 g.
	alimento_data = data.duplicate(true)
	
	# Nome do alimento
	nome.text = str(data.get("nome", "Alimento sem nome"))
	
	# Começa sempre com 100 g
	gramas_atual = 100.0
	gramas.text = "100"
	
	# Atualiza a descrição
	atualizar_descricao()


# ============================================================
# QUANDO ALTERAR AS GRAMAS
# ============================================================

func _on_gramas_text_changed() -> void:
	var texto := gramas.text
	
	# Remove tudo que não seja número ou ponto/vírgula.
	var texto_limpo := ""
	
	for caractere in texto:
		if caractere.is_valid_int() or caractere == "." or caractere == ",":
			texto_limpo += caractere
	
	# Evita vírgula duplicada
	texto_limpo = normalizar_numero(texto_limpo)
	
	# Se o texto original tinha caracteres inválidos,
	# corrige o campo.
	if texto != texto_limpo:
		var posicao := gramas.get_caret_line()
		var coluna := gramas.get_caret_column()
		
		gramas.text = texto_limpo
		
		# Tenta manter o cursor
		gramas.set_caret_line(posicao)
		gramas.set_caret_column(min(coluna, texto_limpo.length()))
	
	# Campo vazio
	if texto_limpo.is_empty():
		return
	
	var valor := texto_limpo.to_float()
	
	# Não permite 0 ou negativo
	if valor <= 0:
		return
	
	gramas_atual = valor
	
	atualizar_descricao()


# ============================================================
# BOTÃO +
# ============================================================

func _on_btn_mais_pressed() -> void:
	gramas_atual += 10.0
	
	gramas.text = formatar_numero(gramas_atual)
	
	atualizar_descricao()


# ============================================================
# BOTÃO -
# ============================================================

func _on_btn_menos_pressed() -> void:
	gramas_atual -= 10.0
	
	# Não deixa ficar menor que 1 g
	if gramas_atual < 1.0:
		gramas_atual = 1.0
	
	gramas.text = formatar_numero(gramas_atual)
	
	atualizar_descricao()


# ============================================================
# ATUALIZAR DESCRIÇÃO
# ============================================================

func atualizar_descricao() -> void:
	if alimento_data.is_empty():
		return
	
	var fator := gramas_atual / 100.0
	
	var texto := ""
	
	texto += "[b]Quantidade:[/b] %.1f g\n\n" % gramas_atual
	
	texto += "[b]Informações nutricionais[/b]\n\n"
	
	texto += "Umidade: %s g\n" % calcular_nutriente("umidade_pct", fator)
	texto += "Energia: %s kcal\n" % calcular_nutriente("energia_kcal", fator)
	texto += "Energia: %s kJ\n" % calcular_nutriente("energia_kj", fator)
	texto += "Proteína: %s g\n" % calcular_nutriente("proteina_g", fator)
	texto += "Lipídeos: %s g\n" % calcular_nutriente("lipideos_g", fator)
	texto += "Colesterol: %s mg\n" % calcular_nutriente("colesterol_mg", fator)
	texto += "Carboidratos: %s g\n" % calcular_nutriente("carboidratos_g", fator)
	texto += "Fibra alimentar: %s g\n" % calcular_nutriente("fibra_alimentar_g", fator)
	texto += "Cinzas: %s g\n" % calcular_nutriente("cinzas_g", fator)
	
	texto += "\n[b]Minerais[/b]\n\n"
	
	texto += "Cálcio: %s mg\n" % calcular_nutriente("calcio_mg", fator)
	texto += "Magnésio: %s mg\n" % calcular_nutriente("magnesio_mg", fator)
	texto += "Manganês: %s mg\n" % calcular_nutriente("manganes_mg", fator)
	texto += "Fósforo: %s mg\n" % calcular_nutriente("fosforo_mg", fator)
	texto += "Ferro: %s mg\n" % calcular_nutriente("ferro_mg", fator)
	texto += "Sódio: %s mg\n" % calcular_nutriente("sodio_mg", fator)
	texto += "Potássio: %s mg\n" % calcular_nutriente("potassio_mg", fator)
	texto += "Cobre: %s mg\n" % calcular_nutriente("cobre_mg", fator)
	texto += "Zinco: %s mg\n" % calcular_nutriente("zinco_mg", fator)
	
	texto += "\n[b]Vitaminas[/b]\n\n"
	
	texto += "Retinol: %s µg\n" % calcular_nutriente("retinol_mcg", fator)
	texto += "RE: %s µg\n" % calcular_nutriente("re_mcg", fator)
	texto += "RAE: %s µg\n" % calcular_nutriente("rae_mcg", fator)
	texto += "Tiamina: %s mg\n" % calcular_nutriente("tiamina_mg", fator)
	texto += "Riboflavina: %s mg\n" % calcular_nutriente("riboflavina_mg", fator)
	texto += "Piridoxina: %s mg\n" % calcular_nutriente("piridoxina_mg", fator)
	texto += "Niacina: %s mg\n" % calcular_nutriente("niacina_mg", fator)
	texto += "Vitamina C: %s mg\n" % calcular_nutriente("vitamina_c_mg", fator)
	
	descricao.text = texto


# ============================================================
# CALCULAR NUTRIENTE
# ============================================================

func calcular_nutriente(chave: String, fator: float) -> String:
	var valor = alimento_data.get(chave, "")
	
	if valor == null:
		return "NA"
	
	var texto := str(valor).strip_edges()
	
	# Valores especiais da tabela
	if texto.is_empty():
		return "-"
	
	if texto.to_upper() == "NA":
		return "NA"
	
	if texto.to_upper() == "TR":
		return "Tr"
	
	# Troca vírgula decimal por ponto
	texto = texto.replace(",", ".")
	
	if not texto.is_valid_float():
		return texto
	
	var numero := texto.to_float()
	var resultado := numero * fator
	
	return formatar_numero(resultado)


# ============================================================
# NORMALIZAR NÚMERO DIGITADO
# ============================================================

func normalizar_numero(texto: String) -> String:
	# Converte vírgula para ponto
	texto = texto.replace(",", ".")
	
	# Permite somente um ponto
	var encontrou_ponto := false
	var resultado := ""
	
	for caractere in texto:
		if caractere == ".":
			if encontrou_ponto:
				continue
			
			encontrou_ponto = true
		
		resultado += caractere
	
	return resultado


# ============================================================
# FORMATAR NÚMERO
# ============================================================

func formatar_numero(valor: float) -> String:
	# Se for inteiro, não mostra .0
	if is_equal_approx(valor, round(valor)):
		return str(int(round(valor)))
	
	return "%.2f" % valor


func _on_btn_adicionar_pressed() -> void:
	var d = {
		"nome" : nome.text,
		"gramas" : gramas_atual,
		"alimento_data" : alimento_data,
	}
	
	GlobalManager.atalhos["panel_novo_alimento"].receber_alimento(d)
