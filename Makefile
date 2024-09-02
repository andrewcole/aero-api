AIRLINE_IATA = $(shell python3 ./build.py targets data.json airlines iata)
AIRLINE_ICAO = $(shell python3 ./build.py targets data.json airlines icao)
targets = $(addsuffix /index.json,$(addprefix api/airlines/iata/,$(AIRLINE_IATA))) $(addsuffix /index.json,$(addprefix api/airlines/icao/,$(AIRLINE_ICAO)))

.PHONY: help
help:
	@echo "make help"
	@echo "make build"
	@echo "make clean"

.PHONY: clean
clean:
	@rm -rf api/

build: $(targets)
	@mkdir -p api

api/airlines/iata/%/index.json: data.json
	@python3 ./build.py generate --output=./api data.json airlines iata $(patsubst %/index.json,%,$(patsubst api/airlines/iata/%,%,$@))

api/airlines/icao/%/index.json: data.json
	@python3 ./build.py generate --output=./api data.json airlines icao $(patsubst %/index.json,%,$(patsubst api/airlines/icao/%,%,$@))
