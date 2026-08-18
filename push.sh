```bash
#!/bin/bash

echo "Digite a mensagem do commit:"
read -r mensagem

if [ -z "$mensagem" ]; then
    echo "A mensagem do commit não pode estar vazia."
    exit 1
fi

echo ""
echo "Adicionando arquivos..."
git add .

echo ""
echo "Criando commit..."
git commit -m "$mensagem"

# Verifica se o commit foi criado
if [ $? -ne 0 ]; then
    echo ""
    echo "Nenhum commit novo foi criado."
    echo "Verificando se existem commits locais para enviar..."

    if [ "$(git rev-list --count origin/main..main)" -gt 0 ]; then
        echo ""
        echo "Existem commits locais pendentes. Enviando para o GitHub..."
        git push
    else
        echo ""
        echo "Nada para enviar."
    fi

    exit 0
fi

echo ""
echo "Enviando para o GitHub..."
git push

echo ""
echo "Concluído!"
```

