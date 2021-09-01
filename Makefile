# Build all the documentation using the PRM-in-XML tools

.PHONY: output pdf

TOOL = riscos-prminxml

all: pdf

output:
	${TOOL} -f index -L logs prmindex.xml
	cat logs/2-build.log

pdf: output
	cd output/html && prince --verbose -o ../../index.pdf -l filelist.txt

zip: output
	rm -f src.zip output.zip
	zip -9r src.zip prmindex.html Makefile src
	zip -9r output.zip output
