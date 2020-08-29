test:
	prove -v -e bin/tmeta t/tm/*.tm

docs:
	./gen-docs > help.md
	./gen-docs --html > doc.md
