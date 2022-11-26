test:
	prove -v -e bin/boda t/boda/*.boda

docs:
	./gen-docs > help.md
	./gen-docs --html > doc.md
