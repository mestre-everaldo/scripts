#!/bin/bash

# Diretório onde os arquivos .mp4 estão localizados
diretorio_mp4="$1"

# Verifica se o diretório foi fornecido como argumento
if [ -z "$diretorio_mp4" ]; then
  echo "Uso: $0 <diretorio_com_arquivos_mp4>"
  exit 1
fi

# Verifica se o diretório existe
if [ ! -d "$diretorio_mp4" ]; then
  echo "Erro: O diretório '$diretorio_mp4' não existe."
  exit 1
fi

# Cria um diretório de saída (opcional, para manter os arquivos originais)
diretorio_mp3="${diretorio_mp4}/mp3_convertidos"
mkdir -p "$diretorio_mp3"

# Encontra todos os arquivos .mp4 no diretório fornecido
find "$diretorio_mp4" -maxdepth 1 -name "*.mp4" -print0 | while IFS= read -r -d $'\0' file; do
  # Obtém o nome do arquivo sem a extensão
  filename=$(basename "$file" .mp4)

  # Define o nome do arquivo de saída .mp3
  output_file="${diretorio_mp3}/${filename}.mp3"

  echo "Convertendo '$file' para '$output_file'..."

  # Executa o comando FFmpeg dentro do container Docker
  docker run --rm \
    -v "${diretorio_mp4}:/input" \
    -v "${diretorio_mp3}:/output" \
    jrottenberg/ffmpeg \
    -i "/input/${filename}.mp4" \
    -vn "/output/${filename}.mp3"

  echo "Conversão concluída para '$output_file'."
done

echo "Processo de conversão concluído."
