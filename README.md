# msfastar <img src="man/figures/msfastar_logo.png" align="right" width="120"/>

An lightweight R package parsing
[FASTA](https://en.wikipedia.org/wiki/FASTA_format) (like those from
[UniProt](https://www.uniprot.org/)) files into an R usable `list` or
`data.frame`. The main function utilizes [regular
expressions](https://en.wikipedia.org/wiki/Regular_expression) to
extract meta data along with the protein sequence. Some functions have been written
in `Rust` to optimize performance.

## Installation

To install, open R and type:

``` r
install.packages("devtools")
devtools::install_github("jeffsocal/msfastar")
```

## Get Started

Its simple to get started, just point the `read_fasta()` function at a
downloaded FASTA file and save as an object.

``` r
library(msfastar)
path_to_fasta <- system.file("extdata", "albu_human.fasta", package = "msfastar")
fasta_data <- read_fasta(path_to_fasta)

#> ℹ Parsing FASTA file albu_human.fasta
#> ✔ Parsing FASTA file albu_human.fasta ... done
#> 

fasta_data[[1]]
#> $accession
#> [1] "P02768"
#> 
#> $protein_name
#> [1] "ALBU_HUMAN"
#> 
#> $gene_name
#> [1] "ALB"
#> 
#> $organism
#> [1] "Homo sapiens"
#> 
#> $description
#> [1] "Albumin"
#> 
#> $sequence
#> [1] "MKWVTFISLLFLFSSAYSRGVFRRDAHKSEVAHRFKDLGEENFKALVLIAFAQYLQQCPFEDHVKLVNEVTEFAKTCVADESAENCDKSLHTLFGDKLCTVATLRETYGEMADCCAKQEPERNECFLQHKDDNPNLPRLVRPEVDVMCTAFHDNEETFLKKYLYEIARRHPYFYAPELLFFAKRYKAAFTECCQAADKAACLLPKLDELRDEGKASSAKQRLKCASLQKFGERAFKAWAVARLSQRFPKAEFAEVSKLVTDLTKVHTECCHGDLLECADDRADLAKYICENQDSISSKLKECCEKPLLEKSHCIAEVENDEMPADLPSLAADFVESKDVCKNYAEAKDVFLGMFLYEYARRHPDYSVVLLLRLAKTYETTLEKCCAAADPHECYAKVFDEFKPLVEEPQNLIKQNCELFEQLGEYKFQNALLVRYTKKVPQVSTPTLVEVSRNLGKVGSKCCKHPEAKRMPCAEDYLSVVLNQLCVLHEKTPVSDRVTKCCTESLVNRRPCFSALEVDETYVPKEFNAETFTFHADICTLSEKERQIKKQTALVELVKHKPKATKEQLKAVMDDFAAFVEKCCKADDKETCFAEEGKKLVAASQAALGL"
```

In addition, the expected peptides can be generated with the `digest()`
function.

``` r
fasta_data <- lapply(fasta_data, digest)

fasta_data[[1]]

#> $accession
#> [1] "P02768"
#> 
#> $protein_name
#> [1] "ALBU_HUMAN"
#> 
#> $gene_name
#> [1] "ALB"
#> 
#> $organism
#> [1] "Homo sapiens"
#> 
#> $description
#> [1] "Albumin"
#> 
#> $sequence
#> [1] "MKWVTFISLLFLFSSAYSRGVFRRDAHKSEVAHRFKDLGEENFKALVLIAFAQYLQQCPFEDHVKLVNEVTEFAKTCVADESAENCDKSLHTLFGDKLCTVATLRETYGEMADCCAKQEPERNECFLQHKDDNPNLPRLVRPEVDVMCTAFHDNEETFLKKYLYEIARRHPYFYAPELLFFAKRYKAAFTECCQAADKAACLLPKLDELRDEGKASSAKQRLKCASLQKFGERAFKAWAVARLSQRFPKAEFAEVSKLVTDLTKVHTECCHGDLLECADDRADLAKYICENQDSISSKLKECCEKPLLEKSHCIAEVENDEMPADLPSLAADFVESKDVCKNYAEAKDVFLGMFLYEYARRHPDYSVVLLLRLAKTYETTLEKCCAAADPHECYAKVFDEFKPLVEEPQNLIKQNCELFEQLGEYKFQNALLVRYTKKVPQVSTPTLVEVSRNLGKVGSKCCKHPEAKRMPCAEDYLSVVLNQLCVLHEKTPVSDRVTKCCTESLVNRRPCFSALEVDETYVPKEFNAETFTFHADICTLSEKERQIKKQTALVELVKHKPKATKEQLKAVMDDFAAFVEKCCKADDKETCFAEEGKKLVAASQAALGL"
#> 
#> $peptides
#>  [1] "AACLLPK"                     "AAFTECCQAADK"               
#>  [3] "AEFAEVSK"                    "ALVLIAFAQYLQQCPFEDHVK"      
#>  [5] "AVMDDFAAFVEK"                "AWAVAR"                     
#>  [7] "CASLQK"                      "CCAAADPHECYAK"              
#>  [9] "CCTESLVNR"                   "DDNPNLPR"                   
#> [11] "DLGEENFK"                    "DVFLGMFLYEYAR"              
#> [13] "EFNAETFTFHADICTLSEK"         "ETCFAEEGK"                  
#> [15] "ETYGEMADCCAK"                "FQNALLVR"                   
#> [17] "HPDYSVVLLLR"                 "HPYFYAPELLFFAK"             
#> [19] "LCTVATLR"                    "LVAASQAALGL"                
#> [21] "LVNEVTEFAK"                  "LVTDLTK"                    
#> [23] "MPCAEDYLSVVLNQLCVLHEK"       "NECFLQHK"                   
#> [25] "NYAEAK"                      "PCFSALEVDETYVPK"            
#> [27] "PEVDVMCTAFHDNEETFLK"         "PLVEEPQNLIK"                
#> [29] "QNCELFEQLGEYK"               "QTALVELVK"                  
#> [31] "SEVAHR"                      "SHCIAEVENDEMPADLPSLAADFVESK"
#> [33] "SLHTLFGDK"                   "TCVADESAENCDK"              
#> [35] "TPVSDR"                      "TYETTLEK"                   
#> [37] "VFDEFK"                      "VHTECCHGDLLECADDR"          
#> [39] "VPQVSTPTLVEVSR"              "WVTFISLLFLFSSAYSR"          
#> [41] "YICENQDSISSK"                "YLYEIAR"
```

Alternatively read_fasta the FASTA file into a `data.frame`.

``` r
library(tidyverse, warn.conflicts = FALSE)
fasta_data <- read_fasta(path_to_fasta) |> as.data.frame() |> as_tibble()

#> ℹ Parsing FASTA file albu_human.fasta
#> ✔ Parsing FASTA file albu_human.fasta ... done

fasta_data
#> # A tibble: 3 × 6
#>   accession protein_name gene_name organism     description          sequence   
#>   <chr>     <chr>        <chr>     <chr>        <chr>                <chr>      
#> 1 P02768    ALBU_HUMAN   ALB       Homo sapiens Albumin              MKWVTFISLL…
#> 2 P02768    ALBU_HUMAN   <NA>      Homo sapiens Isoform 2 of Albumin MKWVTFISLL…
#> 3 P02768    ALBU_HUMAN   <NA>      Homo sapiens Isoform 3 of Albumin MKWVTFISLL…
```
