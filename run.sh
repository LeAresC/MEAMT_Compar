#!/bin/bash

# Interrompe o script imediatamente se der erro em algum notebook
set -e

# Ative seu ambiente virtual aqui (descomente a linha abaixo se for o caso
python -m venv venv
source venv/bin/activate

pip install -r requirements.txt
# Garante que as importações da pasta src/ funcionem corretamente
export PYTHONPATH="$(pwd):$PYTHONPATH"

# Como são 10 arquivos, liberamos 10 processos paralelos
MAX_JOBS=10

echo "Iniciando a execução dos benchamarks..."

# Pega todos os arquivos .ipynb da pasta e joga no xargs
ls notebooks/*.ipynb | xargs -n 1 -P $MAX_JOBS -I {} bash -c '
    ARQUIVO=$(basename "{}")
    echo "Iniciando: $ARQUIVO"
    
    # Executa silenciosamente e salva no próprio arquivo
    python -m jupyter nbconvert --to notebook --execute --inplace "{}"
    
    echo " Concluído: $ARQUIVO"
'

echo "Todas as simulações foram finalizadas com sucesso!"
