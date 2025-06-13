> **Geração das grades estatísticas do IBGE (Censos 2010 e 2022) recortadas para o município de Salvador (BA)**  

Este repositório contém um script em R que:

1. **Faz o download** dos shapefiles da Grade Estatística do IBGE (500 km × 500 km) para os quadrantes `id47` e `id57`, que cobrem Salvador;  
2. **Extrai** e organiza os arquivos em uma estrutura padronizada de pastas;  
3. **Une** os quadrantes correspondentes a cada censo (2010 e 2022);  
4. **Recorta** as grades pelo limite municipal de Salvador obtido via `geobr`;  
5. **Exporta** os resultados finais em formato GeoPackage (`.gpkg`) para uso direto em SIG ou scripts de análise espacial.

---

## Pré-requisitos

| Pacote | Versão mínima | Função principal |
|--------|---------------|------------------|
| **R**  | 4.2 ou superior | Ambiente de execução |
| `tidyverse` | 2.0.0 | Manipulação de dados |
| `sf` | 1.0-14 | Operações espaciais |
| `geobr` | 1.7.0 | Limites municipais do Brasil |

Instalação recomendada:

```r
install.packages(c("tidyverse", "sf", "geobr"))


