# Rdataviz
This repository contains a slide deck entitled "Advanced R Data Visualization," which was presented to UC Berkeley Biostatistics students on 24 February 2015.  The deck was built using the [R](http://www.r-project.org/) package [slidify](http://ramnathv.github.io/slidify/), with support from [knitr](http://cran.r-project.org/web/packages/knitr/index.html) and [pandoc](http://johnmacfarlane.net/pandoc/).  Extensions employed in this deck include:
+ the [deck.js](https://github.com/imakewebthings/deck.js) framework,
+ the [RefManageR](http://cran.r-project.org/web/packages/RefManageR/index.html) bibliography manager, and
+ the [prettify](https://code.google.com/p/google-code-prettify/) syntax highlighter.

The file for the main deck is [index.html](https://saraemoore.github.io/Rdataviz/index.html), built from the [RMarkdown](http://rmarkdown.rstudio.com/) file [index.Rmd]((https://github.com/saraemoore/Rdataviz/blob/gh-pages/index.Rmd). To recompile **in R**, where `~/Downloads/Rdataviz` is the the local git repo's folder (change as appropriate), execute the code below.

```
#library(devtools)
#install_github("ramnathv/slidify")
#install_github("ramnathv/slidifyLibraries")
library(slidify)
setwd("~/Downloads/Rdataviz")
slidify("index.Rmd")
browseURL("index.html")
```

**Note**: To compile as-is, all CSVs from the Kaggle [March Machine Learning "Mania" 2015](http://www.kaggle.com/c/march-machine-learning-mania-2015) competition should be downloaded into `~/Dropbox/kaggle/marchmania2015/`.  Additionally, the following R packages should be installed:
+ [RefManageR](http://cran.r-project.org/web/packages/RefManageR/index.html)
+ ggplot2
+ [munsell](http://cran.r-project.org/web/packages/munsell/index.html)
+ [tidyr](http://cran.r-project.org/web/packages/tidyr/index.html)
+ [scales](http://cran.r-project.org/web/packages/scales/index.html)
+ [RColorBrewer](http://cran.r-project.org/web/packages/RColorBrewer/index.html)
+ [grid](https://stat.ethz.ch/R-manual/R-devel/library/grid/html/00Index.html)
+ [ggdendro](http://cran.r-project.org/web/packages/ggdendro/index.html)
+ [gtable](http://cran.r-project.org/web/packages/gtable/index.html)
+ plotly


[dplyr](http://cran.r-project.org/web/packages/dplyr/index.html) and 


Rough presenter notes are in [pnotes.html](https://saraemoore.github.io/Rdataviz/pnotes.html), built (using [pandoc](http://johnmacfarlane.net/pandoc/)) from the markdown file [pnotes.md](https://github.com/saraemoore/Rdataviz/blob/gh-pages/pnotes.md). To recompile **at the command line**, where `~/Downloads/Rdataviz` is the the local git repo's folder (change as appropriate):

```
cd ~/Downloads/Rdataviz
pandoc pnotes.md -f markdown -t html -s -o pnotes.html
```

**Note**: the `googleVis` graphic on slide 41 requires Flash. Your browser may require additional configuration to display this graphic when working from a local repository.
