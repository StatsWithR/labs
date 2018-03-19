RMD_FILES := $(shell find ./ -name *.Rmd)
HTML_FILES := $(subst Rmd,html,$(RMD_FILES))
LAB_DIRS := $(dir $(RMD_FILES))


all: $(HTML_FILES)
	
$(HTML_FILES): %.html: %.Rmd
	@echo "Compiling $(@F)"
	@cd $(@D); Rscript -e "library(rmarkdown);render('$(<F)', runtime='static', quiet=FALSE)"
	 
clean:
	@rm -f $(HTML_FILES)