AIRLINE_IATA = $(shell python3 ./build.py targets data.json airlines iata)
AIRLINE_ICAO = $(shell python3 ./build.py targets data.json airlines icao)
targets = $(addsuffix /index.json,$(addprefix api/v1/airlines/iata/,$(AIRLINE_IATA))) $(addsuffix /index.json,$(addprefix api/v1/airlines/icao/,$(AIRLINE_ICAO)))

.PHONY: help
help:
	@echo "make help"
	@echo "make clean"
	@echo "make build"

.PHONY: clean
clean:
	@rm -rf api/

.PHONY: build
build: $(targets)

api/v1/airlines/iata/%/index.json: data.json
	@python3 ./build.py generate --output=./api/v1 data.json airlines iata $(patsubst %/index.json,%,$(patsubst api/v1/airlines/iata/%,%,$@))

api/v1/airlines/icao/%/index.json: data.json
	@python3 ./build.py generate --output=./api/v1 data.json airlines icao $(patsubst %/index.json,%,$(patsubst api/v1/airlines/icao/%,%,$@))
