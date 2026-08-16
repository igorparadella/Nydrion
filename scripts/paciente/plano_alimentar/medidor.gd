extends VBoxContainer

var id
var dados = {}
@onready var meta: Label = $medidor4/meta
@onready var atual: Label = $medidor4/nome2
@onready var diferenca: Label = $medidor4/VBoxContainer/nome3
@onready var diferenca_em_porcentagem: Label = $medidor4/VBoxContainer/nome4
@onready var progress_bar: ProgressBar = $ProgressBar


func _ready() -> void:
	if dados.is_empty():
		queue_free()
		return
	
	$medidor4/nome.text = dados[0]
	meta.text = str(dados[2])
	progress_bar.max_value = dados[2]
	
	
	

var ultimo_valor = null
func _process(delta: float) -> void:
	var res = obter_nutriente_total(id)
	if ultimo_valor != res:
		atual.text = str(res)
		progress_bar.value = float(res)
		ultimo_valor = res
		atualizar_cor(float(res),dados[2])

func atualizar_cor(valor_atual: float, valor_maximo: float) -> void:
	if valor_maximo <= 0:
		return

	var diferenca_percentual = abs(valor_atual - valor_maximo) / valor_maximo * 100.0

	if diferenca_percentual <= 5.0:
		# Até 5% para cima ou para baixo
		progress_bar.modulate = Color.GREEN

	elif diferenca_percentual <= 10.0:
		# Entre 5% e 10% para cima ou para baixo
		progress_bar.modulate = Color.YELLOW

	else:
		# Mais de 10% para cima ou para baixo
		progress_bar.modulate = Color.RED

func obter_nutriente_total(nome_nutriente: String) -> float:
	var total := 0.0
	
	var plano = GlobalManager.paciente_aberto.get("plano_alimentar", {})
	var refeicoes = plano.get("refeicoes", {})
	
	for id_refeicao in refeicoes:
		var refeicao = refeicoes[id_refeicao]
		var alimentos = refeicao.get("alimentos", [])
		
		for alimento in alimentos:
			var alimento_data = alimento.get("alimento_data", {})
			
			var valor = alimento_data.get(nome_nutriente, "0")
			var gramas = float(alimento.get("gramas", 0))
			
			# Trata valores como "Tr", "NA", "", etc.
			var valor_nutriente := 0.0
			
			if typeof(valor) == TYPE_STRING:
				valor = valor.replace(",", ".")
				
				if valor.is_valid_float():
					valor_nutriente = float(valor)
			else:
				valor_nutriente = float(valor)
			
			# Valor nutricional da tabela é referente a 100 g
			var quantidade_consumida = valor_nutriente * gramas / 100.0
			
			total += quantidade_consumida
	
	return total
