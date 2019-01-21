HUGO := hugo

all: build

build:
	$(HUGO)

serve:
	$(HUGO) server

deploy: build
	cd public \
	  && git commit -am "Rebuilding site $(shell date)" \
	  && git push origin master
