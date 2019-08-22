test:
	prove -v -e ./tmeta t/tm/*.tm

docs:
	./gen-docs > help.md
	./gen-docs --html > doc.md
