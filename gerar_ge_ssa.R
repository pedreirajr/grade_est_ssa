#(0) Leitura dos pacotes necessários (instalar caso não estejam instalados)
library(tidyverse); library(sf); library(geobr);


# (1) Obtenção da grade estatística ----------------------------------------

# Importante:
## Salvador está compreendida nas grades de 500 X 500 km de ID's 47 e 57
### Como descobrir para outras cidades:
#### Opção (1):
##### Acesse https://portaldemapas.ibge.gov.br/, vá em "Busca" e digite "grade estatística"
##### Depois visualize grids 47 e 57 e veja que ambas contêm Salvador
#### Opção (2):
##### Link da articulação 500 X 500 km: https://geoftp.ibge.gov.br/recortes_para_fins_estatisticos/grade_estatistica/censo_2010/articulacao.jpg

## Links para baixar:
### Checar em "https://geoftp.ibge.gov.br/recortes_para_fins_estatisticos/grade_estatistica/"
#### Censo 2010:
url_id47_2010 <- 'https://geoftp.ibge.gov.br/recortes_para_fins_estatisticos/grade_estatistica/censo_2010/grade_id47.zip'
url_id57_2010 <- 'https://geoftp.ibge.gov.br/recortes_para_fins_estatisticos/grade_estatistica/censo_2010/grade_id57.zip'
#### Censo 2022:
url_id47_2022 <- 'https://geoftp.ibge.gov.br/recortes_para_fins_estatisticos/grade_estatistica/censo_2022/grade_estatistica/grade_id47.zip'
url_id57_2022 <- 'https://geoftp.ibge.gov.br/recortes_para_fins_estatisticos/grade_estatistica/censo_2022/grade_estatistica/grade_id57.zip'

## (1a) Fazendo o donwload das urls:
urls <- c(url_id47_2010,url_id57_2010,url_id47_2022,url_id57_2022)
names(urls) <- c('id47_2010','id57_2010','id47_2022','id57_2022')

### Criação de pastas para armazenamento dos arquivos
dir_data = 'data'; dir_geo = 'data/ge_shp' 
dir.create(dir_data)
dir.create(dir_geo)

### Download dos arquivos
sapply(urls, function(i) {
  download.file(i,
                destfile = paste0('data/',
                                  names(which(i == urls)),
                                  '.zip'
                )
  )
}
)

## (1b) Extraindo os arquivos .shp dos arquivos .zip baixados
### Lista todos os arquivos .zip da pasta '/data'.
zips <- list.files(dir_data, pattern = 'zip')

### Cria diretórios específicos para os censos 2010 e 2022
dir.create(paste0(dir_geo,'/2010'))
dir.create(paste0(dir_geo,'/2022'))

### Extraindo os arquivos .shp
sapply(paste0(dir_data,'/',zips), function(i) {
  if(grepl('2010',i)){
    unzip(i, exdir = paste0(dir_geo,'/2010/'))
  } else
  {unzip(i, exdir = paste0(dir_geo,'/2022/'))}
  file.rename
}
)

# (2) Produzindo grade estatística para Salvador (2010 e 2022) ------------

## (2a) Lendo ge's nas pastas:
ge47_2010 <- st_read('data/ge_shp/2010/grade_id47.shp')
ge57_2010 <- st_read('data/ge_shp/2010/grade_id57.shp')
ge47_2022 <- st_read('data/ge_shp/2022/grade_id47.shp')
ge57_2022 <- st_read('data/ge_shp/2022/grade_id57.shp')
ge_2010 <- rbind(ge47_2010, ge57_2010)
ge_2022 <- rbind(ge47_2022, ge57_2022)

## (2b) Lendo mapa de salvador a partir do pacote geobr
ssa <- read_municipality(code_muni = lookup_muni('Salvador')$code_muni,
                         simplified = F)

## (2c) Extraindo somente as quadrículas que interceptam o mapa de salvador
### Checando CRS:
st_crs(ssa) == st_crs(ge_2010) # Ambos SIRGAS 2000
st_crs(ssa) == st_crs(ge_2022) # Ambos SIRGAS 2000

### Obtendo interseção
ge_ssa2010 <- ge_2010 %>% st_intersection(ssa)
ge_ssa2022 <- ge_2022 %>% st_intersection(ssa)

## (2d) Visualizando:
ge_ssa2010 %>% ggplot() + geom_sf()
ge_ssa2022 %>% ggplot() + geom_sf()

## (2e) Salvando
### Criando diretório para armazenar as grades dos dois censos
dir_output <- 'ge_ssa_out'
dir.create(dir_output)

### Salvando em formato .gpkg
st_write(ge_ssa2010, paste0(dir_output,'ge_ssa2010.gpkg'))
st_write(ge_ssa2022, paste0(dir_output,'ge_ssa2022.gpkg'))
