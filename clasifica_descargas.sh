#!/bin/bash

######## para ejecutar
## bash <(curl -sL https://raw.githubusercontent.com/tuusuario/mis-scripts/main/clasifica_series.sh)

origen="/media/multimedia/Descargas/complete"
destino_series="/media/multimedia/Descargas/capitulospendientes"
destino_pelis="/media/multimedia/peliculas"

mkdir -p "$destino_series" "$destino_pelis"

find "$origen" -type f \( -iname "*.mkv" -o -iname "*.mp4" -o -iname "*.avi" \) | while read -r archivo_origen; do
    nombre_archivo=$(basename "$archivo_origen")
    ruta_relativa="${archivo_origen#$origen/}"
    
    # Regex ESTRICTO: NxM, SxE, NxE (números 00-99 + x/X/e/E + números 00-99)
    # NO coge años (1995), resoluciones (2160p), codecs (x265)
# Opción 1: Aritmético con ignore error (mejor)
if [[ "$temp" =~ ^[0-9]{1,2}$ ]] && [[ "$cap" =~ ^[0-9]{1,2}$ ]] && 
   temp_ok=$((10#$temp)) && [[ $temp_ok -ge 1 && $temp_ok -le 99 ]] &&
   cap_ok=$((10#$cap)) && [[ $cap_ok -ge 1 && $cap_ok -le 99 ]]; then

        temp="${BASH_REMATCH[1]}"
        cap="${BASH_REMATCH[2]}"
        if [[ "$temp" =~ ^[1-9][0-9]?$ ]] && [[ "$cap" =~ ^[1-9][0-9]?$ ]]; then    
            archivo_destino="$destino_series/$ruta_relativa"
            mkdir -p "$(dirname "$archivo_destino")"
            
            if [[ ! -e "$archivo_destino" ]]; then
                ln "$archivo_origen" "$archivo_destino"
                echo "✅ SERIE $temp""x""$cap → $archivo_destino"
            else
                echo "⏭️ Serie existe: $archivo_destino"
            fi
            continue
        fi
    fi
    
    # PELÍCULA (incluye falsos positivos corregidos)
    archivo_destino="$destino_pelis/$ruta_relativa"
    mkdir -p "$(dirname "$archivo_destino")"
    
    if [[ ! -e "$archivo_destino" ]]; then
        #ln "$archivo_origen" "$archivo_destino"
        echo "🎥 PELÍCULA → $archivo_destino"
    else
        echo "⏭️ Peli existe: $archivo_destino"
    fi
done
