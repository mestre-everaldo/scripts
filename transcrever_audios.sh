#!/bin/bash

# Diretório contendo os arquivos MP3 (o diretório atual por padrão)
diretorio_mp3="${1:-.}"

# Modelo Whisper a ser usado
modelo="medium"

# Idioma
idioma="pt"

# Diretório de saída para as transcrições
diretorio_saida="${diretorio_mp3}/whisper"

# Cria o diretório de saída se não existir
mkdir -p "${diretorio_saida}"

# Encontra todos os arquivos .mp3 no diretório especificado
find "${diretorio_mp3}" -maxdepth 1 -name "*.mp3" -print0 | while IFS= read -r -d $'\0' file; do
  # Obtém o nome base do arquivo (sem a extensão)
  nome_base=$(basename "${file}" .mp3)

  # Caminho base para os arquivos de saída
  saida_base="${diretorio_saida}/${nome_base}"

  echo "Transcrevendo arquivo: ${file}"

  # Executa o comando whisper para gerar as transcrições em vários formatos
  whisper "${file}" \
    --model "${modelo}" \
    --language "${idioma}" \
    --output_dir "${diretorio_saida}" \
    --output_format all \
    --task transcribe \

  echo "Transcrição concluída para: ${file}"
done

echo "Processo de transcrição concluído."

