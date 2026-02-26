#!/bin/bash

origen="/media/multimedia/Descargas/complete"
destino_series="/media/multimedia/Descargas/capitulospendientes"
destino_pelis="/media/multimedia/peliculas"

mkdir -p "$destino_series" "$destino_pelis"

find "$origen" -type f \( -iname "*.mkv" -o -iname "*.mp4" -o -iname "*.avi" \) | while read -r archivo_origen; do
    nombre_archivo=$(basename "$archivo_origen")
    ruta_relativa="${archivo_origen#$origen/}"
    
    # Regex → SERIES (SIN (( )) aritmético!)
    if [[ "$nombre_archivo" =~ ([0-9]{1,2})[xXeEsS]([0-9]{1,2}) ]]; then
        temp="${BASH_REMATCH[1]}"
        cap="${BASH_REMATCH[2]}"
        # SOLO string: ignora solo "00x00"
        if [[ "$temp$cap" != *"00"* ]]; then  # 1x09=109 != *00*
            archivo_destino="$destino_series/$ruta_relativa"
            mkdir -p "$(dirname "$archivo_destino")"
            if [[ ! -e "$archivo_destino" ]]; then
                #ln "$archivo_origen" "$archivo_destino"
                echo "✅ SERIE $temp""x""$cap → $archivo_destino"
            else
                echo "⏭️ Serie existe"
            fi
            continue
        fi
    fi
    
    # PELÍCULA hard link
    archivo_destino="$destino_pelis/$ruta_relativa"
    mkdir -p "$(dirname "$archivo_destino")"
    if [[ ! -e "$archivo_destino" ]]; then
        #ln "$archivo_origen" "$archivo_destino"
        echo "🎥 PELÍCULA → $archivo_destino"
    else
        echo "⏭️ Peli existe"
    fi
done
