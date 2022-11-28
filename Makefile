test:
	prove -v -e bin/termie t/termie/*.termie

docs:
	./gen-docs > help.md
	./gen-docs --html > doc.md
