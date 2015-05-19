
# job names must be in [a-zA-Z_]
PROJ ?= $(shell whoami)_$(shell date +%s)

define HELPDOC

## TARGETS

	new   - create the tutorial project

	help 	- print this help

## VARIABLES

	(None)

## MORE INFO

  https://mana.mozilla.org/wiki/display/CLOUDSERVICES/Exploring+with+the+Mozilla+Data+Pipeline+Demo

endef
export HELPDOC

define NEXTSTEPS

## Next steps

cd jobs/$(PROJ)
make help

endef
export NEXTSTEPS


# for now.
new: new_dice


help:
	@echo "$$HELPDOC"

validate:
	@# name problem:  project must be [^a-zA-Z0-9_]+ $(PROJ)
	@echo "$(PROJ)"  | grep -E -v '[^a-zA-Z0-9_]+' > /dev/null

new_dice: validate
	mkdir -p jobs/$(PROJ)
	cp -r src/dice/* jobs/$(PROJ)

	perl -pi -e s/dice_graph_job_name/$(PROJ)_dice_graph/g jobs/$(PROJ)/*
	@echo "$$NEXTSTEPS"

clean:
	@echo "to clean: \n"
	@echo "rm -rf jobs"

