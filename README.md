> **Geração das grades estatísticas do IBGE (Censos 2010 e 2022) recortadas para o município de Salvador (BA)**  

Este repositório contém um script em R que:

1. **Faz o download** dos shapefiles da Grade Estatística do IBGE (500 km × 500 km) para os quadrantes `id47` e `id57`, que cobrem Salvador;  
2. **Une** estes quadrantes e obtém a interseção com o polígono do município de Salvador obtido via `geobr`;  
3. **Exporta** os resultados finais em formato GeoPackage (`.gpkg`).


