# Academic journal subscription costs in various countries: a review

## Background

This repository provides source data files and the analysis code for the ongoing review of academic journal subscription price information and its availability across different countries. The manuscript is being prepared in [Google docs](https://docs.google.com/document/d/1EQxxvXYcpx2Lk80XXZXG4eagDx6mR1S1Sg3V-EDcamk/edit#). Feedback, criticism, and suggestions are welcome.


## Analysis source code

[A summary of the analyses](overview.pdf) can be reproduced by executing [main.R](main.R) in R. 

## Source data files

The data for each country or organization is in a separate folder, including the available references, licensing and access date information:

 * [Argentina](Argentina)
 * [Australia](Australia)
 * [Brazil](Brazil)
 * [Canada](Canada)
 * [Chile](Chile)
 * [Finland](Finland)
 * [France](France)
 * [Germany](Germany)
 * [HongKong](HongKong)
 * [Netherlands](Netherlands)
 * [NewZealand](NewZealand)
 * [Nigeria](Nigeria)
 * [OECD](OECD): annual currency exchange rates
 * [Switzerland](Switzerland)
 * [UK](UK)
 * [US](US)

The auxiliary data files include:

 * [publisher_synonymes.csv](publisher_synonymes.csv): this table
   indicates the publisher names that have been combined in the
   analysis



## Notes

Kävin läpi näitä kv. aineistoja. Useamman vuoden ajalle löytyy dataa
maista Argentiina, Suomi, Ranska, Alankomaat, Iso-Britannia. Näistä
löytyy/löysin kustantajakohtaisia hintatietoja (ainakin joidenkin
kustantajien osalta).

- Alustava taulukko jossa kokonaiskustannus per maa/vuosi/kustantaja:
  table_summarized.csv (valuuttamuunnoksia ei huomioitu, mitään
  tarkistuksia ei ole tehty). Tämä vertailu pitänee rajata vain niihin
  muutamiin suurimpiin kustantajiin joista on tieto saatavissa
  useimmista maista. Lisäksi pitäisi huolella varmistaa että luvut
  ovat vertailukelpoisia mukaan otettavien maitten osalta.

- Lisäksi pitäisi miettiä mitä muita yhteenvetoja tarvittaisiin
  kv. vertailua varten. Maa/vuosi/kustantaja-vertailu on yksi, mutta
  sen lisäksi voitaisiin haalia kokoon pelkät maakohtaiset
  kokonaismaksutiedot (ilman kustantajatietoa) isommalle määrälle
  maita). Ja näitä aineistoja voitaisiin vertailla BKT:hen,
  yliopistojen ranking-listoihin ym kuten oli puhe. Mutta pitäisiköhän
  näiden mainittujen lisäksi koota vielä muuta?

- Liitteenä myös alustava taulukko jossa kaikki ne tiedot jotka löysin
  useammalle maalle vertailua varten: table_full.csv (pitäisi tosin
  tarkistella monia asioita ennen kuin data on julkaisukelpoista).

- Julkaisijanimistä on useita eri kirjoitusmuotoja. Tein alustavan
  taulukon jossa näitä ryhmitelty yhteen, mutta pitäisi tehdä tarkempi
  linjanveto millä kriteereillä yhdistellään (publisher_synonymes.csv)

- Valuuttamuunnokset pitänee tehdä vuosittain (sama resoluutio kuin
  aineistoilla). Onko suosituksia mitä lähdettä käytettäisiin
  historiallisten valuuttakurssien hakuun (EUR/USD/GBP).

- Huomiotta jätettyjä tietoja: Joidenkin maiden osalta on saatavilla
  täydentäviä tietoja (julkaisun tyyppi lehti/kirja/e-lehti tms),
  instituutiokohtaiset tiedot, instituution tyyppi (yliopisto / AMKK /
  tms) jne. Periaatteessa sama koskee Materials-kenttää (esim
  wiley-blac; wiley-blackwell; wiley-blackwell (2;6%); wiley-blackwell
  (wiley journals); wiley-blacwell voitaisiin ehkä yhdistää..). Mutta
  tämä tietysti kandee tehdä vain, jos Materials-kenttää aiotaan
  ylipäänsä tutkia tarkemmin. Ja sama homma Resource.type kentän
  kanssa. Organisaatiotasolla on mukana yliopistoja,
  tutkimuslaitoksia, oppilaitoksia, kirjastoja, Suomen akatemia yms.,
  viranomaisia.. eli vertailu voi olla hankalaa. Organisaatiotyyppi
  (tutkimusinstituutti/yliopisto/AMKK/Muu) saatavissa Suomi-datalle,
  mutta ei näyttänyt olevan muissa aineistoissa eli jätettäneen
  huomiotta. Tai voidaan vielä koittaa penkoa tarkemmin jos vastaavaa
  luokittelua voitaisiin tehdä muitten maitten osalta. Jättäisin
  kuitenkin toistaiseksi tekemättä. Kanadalle ei löytynyt
  julkaisijatietoa, pelkät tilausnimikkeet (national post, new york
  times..) joten jätin Kanadan nyt pois.







