# Makefile to interact with terraform
SHELL := /bin/bash

ifndef ACCNAME
$(error ACCNAME is not set)
endif

ifndef ENVNAME
$(error ENVNAME is not set)
endif

ifndef REGION
$(error REGION is not set)
endif

# vars to import
VARS=-var "accname=$(ACCNAME)" \
-var "envname=$(ENVNAME)" \
-var "aws_region=$(REGION)"

# Build tfvars hierarchy for import
VARFILE=
ifneq (,$(wildcard tfvars/default.tfvars))
    VARFILE=-var-file=tfvars/default.tfvars
endif
ifneq (,$(wildcard tfvars/$(ACCNAME).tfvars))
    VARFILE+= -var-file=tfvars/$(ACCNAME).tfvars
endif
ifneq (,$(wildcard tfvars/$(ACCNAME)_$(REGION).tfvars))
    VARFILE+= -var-file=tfvars/$(ACCNAME)_$(REGION).tfvars
endif
ifneq (,$(wildcard tfvars/$(ACCNAME)_$(ENVNAME).tfvars))
    VARFILE+= -var-file=tfvars/$(ACCNAME)_$(ENVNAME).tfvars
endif
ifneq (,$(wildcard tfvars/$(ACCNAME)_$(ENVNAME)_$(REGION).tfvars))
    VARFILE+= -var-file=tfvars/$(ACCNAME)_$(ENVNAME)_$(REGION).tfvars
endif

GPATH=$(shell git rev-parse --git-dir)
CPATH=$(shell pwd)
APATH=$(subst .git,,$(GPATH))
NPATH=$(subst $(APATH),,$(CPATH))
BASENAME=$(shell basename `git rev-parse --show-toplevel`)

FUNCTION="poc-git-actions"

SF_BUCKET="terraform-states-$(ACCNAME)"
SF_KEY="$(ENVNAME)/services/$(FUNCTION)/$(REGION)/terraform.tfstate"

SF_REGION="us-east-1"

export AWS_DEFAULT_REGION=$(REGION)

begin: plan

clean:
	rm -rf .terraform ./modules tfplan
init: clean
	terraform get .
	terraform init -backend-config="bucket=$(SF_BUCKET)" -backend-config="key=$(SF_KEY)" -backend-config="region=$(SF_REGION)"

refresh: init
	terraform refresh $(VARS) $(VARFILE) .

plan: init
	terraform plan -detailed-exitcode $(VARS) $(VARFILE) -out tfplan .;EXC=$$?;if [ $$EXC -eq 1 ]; then exit 1; else if [ $$EXC -eq 0 || $$EXC -eq 2 ]; then rm -f tfplan; fi; exit 0; fi;

apply:
	terraform apply tfplan
	rm tfplan
	terraform taint null_resource.build
	
destroy: init
	terraform plan -destroy $(VARS) $(VARFILE) .
	terraform destroy $(VARS) $(VARFILE) .
