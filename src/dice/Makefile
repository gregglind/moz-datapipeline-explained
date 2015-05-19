
PROJ ?= $(shell whoami)-$(shell date +%s)

define HELPDOC

## TARGETS

	run 	- run the job  (load)
	stop 	- stop the job (unload)

	help 	- print this help

## VARIABLES

	(None)

## MORE INFO

  https://mana.mozilla.org/wiki/display/CLOUDSERVICES/Exploring+with+the+Mozilla+Data+Pipeline+Demo

## YOUR JOB:

  https://pipeline-prototype-cep.dev.mozaws.net/#plugins/filters/PrototypeSandbox-dice_graph_job_name

endef
export HELPDOC

help:
	@echo "$$HELPDOC"

check: exists-heka-sbmgr

exists-heka-sbmgr:
	@(which heka-sbmgr > /dev/null) || (echo "\n fix: install heka-sbmgr from https://github.com/mozilla-services/heka/releases \n" && false )

run: check
	heka-sbmgr -config=sbmgr.toml -action=load -script=dice_graph.lua -scriptconfig=dice_graph.toml
	@echo "open https://pipeline-prototype-cep.dev.mozaws.net/#plugins/filters/PrototypeSandbox-dice_graph_job_name"

stop: check
	heka-sbmgr -config=sbmgr.toml -action=unload -filtername=dice_graph_job_name
	@echo "open https://pipeline-prototype-cep.dev.mozaws.net/#plugins/filters/PrototypeSandbox-dice_graph_job_name"

