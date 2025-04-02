# Required packages
install.packages("rvest")
install.packages("stringr")
install.packages("dplyr")

# Load libraries
library(rvest)
library(stringr)
library(dplyr)

# Base URL
base_url <- "https://www.vagalume.com.br"

# List of hrefs to scrape
hrefs <- c(
  "/shakira/punteria-with-cardi-b.html",
  "/shakira/la-fuerte-with-bizarrap.html",
  "/shakira/tiempo-sin-verte.html",
  "/shakira/cohete-feat-rauw-alejandro.html",
  "/shakira/entre-parentesis-feat-grupo-frontera.html",
  "/shakira/como-donde-y-cuando.html",
  "/shakira/nassau.html",
  "/shakira/ultima.html",
  "/shakira/te-felicito-feat-rauw-alejandro.html",
  "/shakira/monotonia-feat-ozuna.html",
  "/shakira/bzrp-music-sessions-53.html",
  "/shakira/tqg-with-karol-g.html",
  "/shakira/acrostico.html",
  "/shakira/copa-vacia-with-manuel-turizo.html",
  "/shakira/el-jefe-part-fuerza-regida.html",
  "/shakira/bzrp-music-sessions-53-tiesto-remix.html",
  "/shakira/punteria-with-cardi-b-vinyl-version.html",
  "/shakira/me-enamore.html",
  "/shakira/nada.html",
  "/shakira/chantaje-feat-maluma.html",
  "/shakira/when-a-woman.html",
  "/shakira/amarillo.html",
  "/shakira/perro-fiel-part-nicky-jam.html",
  "/shakira/trap-ft-maluma.html",
  "/shakira/comme-moi-feat-black-m.html",
  "/shakira/coconut-tree.html",
  "/shakira/la-bicicleta.html",
  "/shakira/deja-vu.html",
  "/shakira/what-we-said-feat-magic.html",
  "/shakira/toneladas.html",
  "/shakira/cant-remember-to-forget-you-feat-rihanna.html",
  "/shakira/empire.html",
  "/shakira/you-dont-care-about-me.html",
  "/shakira/dare-la-la-la.html",
  "/shakira/cut-me-deep-feat-magic.html",
  "/shakira/23.html",
  "/shakira/the-one-thing.html",
  "/shakira/medicine-feat-blake-shelton.html",
  "/shakira/spotlight.html",
  "/shakira/broken-record.html",
  "/shakira/nunca-me-acuerdo-de-olvidarte.html",
  "/shakira/loca-por-ti.html",
  "/shakira/la-la-la.html",
  "/shakira/chasing-shadows.html",
  "/shakira/that-way.html",
  "/shakira/la-la-la-brasil-2014-part-carlinhos-brown.html",
  "/shakira/sale-el-sol.html",
  "/shakira/loca.html",
  "/shakira/antes-de-las-seis.html",
  "/shakira/gordita-feat-calle-13.html",
  "/shakira/addicted-to-you.html",
  "/shakira/lo-que-mas.html",
  "/shakira/mariposas.html",
  "/shakira/rabiosa-feat-el-cata.html",
  "/shakira/devocion.html",
  "/shakira/islands.html",
  "/shakira/tu-boca.html",
  "/shakira/waka-waka-esto-es-africa.html",
  "/shakira/loca-ft-dizzee-rascal.html",
  "/shakira/rabiosa-feat-pitbull.html",
  "/shakira/waka-waka-this-time-for-africa.html",
  "/shakira/she-wolf.html",
  "/shakira/did-it-again.html",
  "/shakira/long-time.html",
  "/shakira/why-wait.html",
  "/shakira/good-stuff.html",
  "/shakira/men-in-this-town.html",
  "/shakira/gipsy.html",
  "/shakira/spy-featuring-wyclef-jean.html",
  "/shakira/mon-amour.html",
  "/shakira/lo-hecho-esta-hecho.html",
  "/shakira/anos-luz.html",
  "/shakira/loba.html",
  "/shakira/how-do-you-do.html",
  "/shakira/hips-dont-lie.html",
  "/shakira/illegal.html",
  "/shakira/animal-city.html",
  "/shakira/dont-bother.html",
  "/shakira/the-day-and-the-time.html",
  "/shakira/dreams-for-plans.html",
  "/shakira/hey-you.html",
  "/shakira/your-embrace.html",
  "/shakira/costume-makes-the-clown.html",
  "/shakira/something.html",
  "/shakira/timor.html",
  "/shakira/la-tortura-feat-alejandro-sanz.html",
  "/shakira/en-tus-pupilas.html",
  "/shakira/la-pared.html",
  "/shakira/la-tortura-feat-alejandro-sanz.html",
  "/shakira/obtener-un-si.html",
  "/shakira/dia-especial.html",
  "/shakira/escondite-ingles.html",
  "/shakira/no.html",
  "/shakira/las-de-la-intuicion.html",
  "/shakira/dia-de-enero.html",
  "/shakira/lo-imprescindible.html",
  "/shakira/suerte.html",
  "/shakira/underneath-your-clothes.html",
  "/shakira/te-aviso-te-anuncio-tango.html",
  "/shakira/que-me-quedes-tu.html",
  "/shakira/rules.html",
  "/shakira/the-one.html",
  "/shakira/ready-for-the-good-times.html",
  "/shakira/fool.html",
  "/shakira/te-dejo-madrid.html",
  "/shakira/poem-to-a-horse.html",
  "/shakira/eyes-like-yours.html",
  "/shakira/whenever-wherever.html",
  "/shakira/objection-tango.html",
  "/shakira/ciega-sordomuda.html",
  "/shakira/si-te-vas.html",
  "/shakira/moscas-en-la-casa.html",
  "/shakira/no-creo.html",
  "/shakira/inevitable.html",
  "/shakira/octavo-dia.html",
  "/shakira/que-vuelvas.html",
  "/shakira/tu-letras.html",
  "/shakira/donde-estan-los-ladrones.html",
  "/shakira/sombra-de-ti.html",
  "/shakira/ojos-asi.html",
  "/shakira/estoy-aqui.html",
  "/shakira/antologia.html",
  "/shakira/un-poco-de-amor.html",
  "/shakira/quiero.html",
  "/shakira/te-necesito.html",
  "/shakira/vuelve.html",
  "/shakira/te-espero-sentada.html",
  "/shakira/pies-descalzos-suenos-blancos.html",
  "/shakira/pienso-en-ti.html",
  "/shakira/donde-estas-corazon.html",
  "/shakira/se-quiere-se-mata.html",
  "/shakira/eres.html",
  "/shakira/ultimo-momento.html",
  "/shakira/tu-seras-la-historia-de-mi-vida.html",
  "/shakira/peligro.html",
  "/shakira/quince-anos.html",
  "/shakira/brujeria.html",
  "/shakira/eterno-amor.html",
  "/shakira/controlas-mi-destino.html",
  "/shakira/este-amor-es-lo-mas-bello-del-mundo.html",
  "/shakira/1968.html",
  "/shakira/suenos.html",
  "/shakira/esta-noche-voy-contigo.html",
  "/shakira/lejos-de-tu-amor.html",
  "/shakira/magia.html",
  "/shakira/cuentas-conmigo.html",
  "/shakira/cazador-de-amor.html",
  "/shakira/gafas-oscuras.html",
  "/shakira/necesito-de-ti-2.html",
  "/shakira/lejos-de-tu-amor.html"
  
)

# Function to scrape data for a single URL
scrape_song_data <- function(href) {
  # Construct full URL
  url <- paste0(base_url, href)
  
  # Read page
  page <- tryCatch({
    read_html(url)
  }, error = function(e) {
    return(NULL)
  })
  
  if (is.null(page)) {
    return(NULL)
  }
  
  # Extract song details
  titulo_cancao <- page %>%
    html_node(".col1-2-1 h1") %>%
    html_text() %>%
    str_remove("\\(.*\\)") %>%
    str_trim()
  
  artista_convidado <- page %>%
    html_node("h1 span") %>%
    html_text() %>%
    str_remove_all("[()]") %>%
    str_trim() %>%
    str_remove("(?i)^(With|Feat\\.|Part\\.)\\s*")
  
  album <- page %>%
    html_node("h3 a small") %>%
    html_text() %>%
    str_trim()
  
  letra <- page %>%
    html_node("#lyrics") %>%
    html_text() %>%
    str_squish()
  
  letra <- str_replace_all(letra, "(?<=\\w|['\\),!?])(?=[A-Z])", " ")
  
  # Return as a tibble
  tibble(
    Titulo_Cancao = titulo_cancao,
    Artista_Convidado = artista_convidado,
    Album = album,
    Letra = letra,
    URL = url
  )
}

# Scrape all URLs
dados_musicas <- bind_rows(lapply(hrefs, scrape_song_data))

# Print the data
print(dados_musicas)

# Save the data to a CSV file
write.csv(dados_musicas, "dados_musicas.csv", row.names = FALSE)

