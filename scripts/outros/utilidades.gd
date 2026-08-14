extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func calcular_imc(peso: float, altura: float) -> float:
	if peso <= 0 or altura <= 0:
		return 0.0
	
	var imc = peso / (altura * altura)
	return snapped(imc, 0.01)

func classificar_imc(imc: float) -> String:
	if imc <= 0:
		return "Inválido"
	elif imc < 18.5:
		return "Abaixo do peso"
	elif imc < 25.0:
		return "Peso normal"
	elif imc < 30.0:
		return "Sobrepeso"
	elif imc < 35.0:
		return "Obesidade grau I"
	elif imc < 40.0:
		return "Obesidade grau II"
	else:
		return "Obesidade grau III"

func calcular_tmb_homem(peso: float, altura_cm: float, idade: int) -> float:
	if peso <= 0 or altura_cm <= 0 or idade <= 0:
		return 0.0
	
	return (10.0 * peso) + (6.25 * altura_cm) - (5.0 * idade) + 5.0

func calcular_tmb_mulher(peso: float, altura_cm: float, idade: int) -> float:
	if peso <= 0 or altura_cm <= 0 or idade <= 0:
		return 0.0
	
	return (10.0 * peso) + (6.25 * altura_cm) - (5.0 * idade) - 161.0

func calcular_get(tmb: float, fator_atividade: float) -> float:
	if tmb <= 0 or fator_atividade <= 0:
		return 0.0
	
	return snapped(tmb * fator_atividade, 1.0)

var fatores_atividade = {
	"Sedentário": 1.2,
	"Levemente ativo": 1.375,
	"Moderadamente ativo": 1.55,
	"Muito ativo": 1.725,
	"Extremamente ativo": 1.9
}

func calcular_agua(peso: float, ml_por_kg: float = 35.0) -> float:
	if peso <= 0:
		return 0.0
	
	return snapped(peso * ml_por_kg, 50.0)

func calcular_massa_gordura(peso: float, percentual_gordura: float) -> float:
	if peso <= 0 or percentual_gordura < 0:
		return 0.0
	
	return snapped(peso * (percentual_gordura / 100.0), 0.01)

func calcular_massa_magra(peso: float, percentual_gordura: float) -> float:
	if peso <= 0 or percentual_gordura < 0:
		return 0.0
	
	var massa_gordura = calcular_massa_gordura(peso, percentual_gordura)
	
	return snapped(peso - massa_gordura, 0.01)

func calcular_variacao_peso(peso_anterior: float, peso_atual: float) -> float:
	if peso_anterior <= 0:
		return 0.0
	
	return snapped(peso_atual - peso_anterior, 0.01)

func calcular_variacao_percentual(peso_anterior: float, peso_atual: float) -> float:
	if peso_anterior <= 0:
		return 0.0
	
	return snapped(((peso_atual - peso_anterior) / peso_anterior) * 100.0, 0.01)

func calcular_meta_calorica(get_calorias: float, ajuste: float) -> float:
	if get_calorias <= 0:
		return 0.0
	
	return snapped(get_calorias + ajuste, 1.0)
