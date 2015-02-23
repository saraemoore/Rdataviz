DELAY = 1000

RMD_FILE   =  $(wildcard *.Rmd)
HTML_FILE  = $(patsubst %.Rmd, %.html, $(RMD_FILES))
PDF_FILE   = $(patsubst %.html, %.pdf, $(HTML_FILES))

pdf: $(PDF_FILE)
html: $(HTML_FILE)
all: pdf html



%.pdf: %.html
  casperjs makepdf.js $< $@ $(DELAY)

%.html: %.Rmd
  cd $(dir $<) && Rscript -e "slidify::slidify('index.Rmd')" && cd ..