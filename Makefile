NOW := $(shell TZ=UTC date +%Y-%m-%dT%H:%M:%S%z)

build:
	$(HUGO)

deploy: build
	cd public \
&& git add . \
&& git commit -am "Rebuild site ($(NOW))" \
&& git push origin master
