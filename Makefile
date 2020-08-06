SHELL := /bin/bash
RM = rm --recursive --force
WGET =  wget --timeout=30 --no-check-certificate
VENVDIR = .venv
ACTIVATE = source $(VENVDIR)/bin/activate 
PYTHON = $(ACTIVATE) && python 
# pylint: 'C' is conventions category, W0311 is indent warnings, --reports=y for overall report
PYTHON_LINT = pyLint --disable=C 

# Changes for installs on native Windows:
ifeq ($(OS),Windows_NT) 
	SHELL = bash.exe
	ACTIVATE = . $(VENVDIR)/Scripts/activate
endif

.PHONY: dataset clean venv clean-venv pyVenvCheck pyLint


# For the DBLP dataset:
dataset: dataset/dblp.dtd dataset/dblp.xml
dataset/dblp.dtd:
	cd dataset && $(WGET) https://dblp.uni-trier.de/xml/dblp.dtd 
dataset/dblp.xml.gz:
	cd dataset && $(WGET) https://dblp.uni-trier.de/xml/dblp.xml.gz
dataset/dblp.xml: dataset/dblp.xml.gz
	gzip --keep --decompress $< 


clean: 
	-$(RM) dataset/dblp.*


# For the python virtual environment:
CHECK_ACTIVE = python -c "import sys; assert getattr(sys, 'base_prefix',  sys.exec_prefix) != sys.prefix, '$(INACTIVE_MSG)'"
INACTIVE_MSG = pyVenv is not activated!!! \n
INACTIVE_MSG +=Command to activate:   $(ACTIVATE) \n
INACTIVE_MSG +=Command to deactivate: deactivate \n
INACTIVE_MSG +=Retry after activating pyVenv.  Exiting now...
pyVenvCheck: venv
	@$(CHECK_ACTIVE)
	@echo 'pyVenv seems activated, good'
venv: $(VENVDIR)/.pipMarker
$(VENVDIR)/.pipMarker: $(VENVDIR)/.venvMarker requirements.txt
	$(ACTIVATE) && pip install --requirement requirements.txt
	touch $@
$(VENVDIR)/.venvMarker: 
	@echo -n 'Making new $(VENVDIR) using: ' && python --version
	python -m venv $(VENVDIR)
	$(PYTHON) -m pip install --upgrade setuptools pip
	touch $@
clean-venv:
	- $(RM) $(VENVDIR)
	@ echo "Note: Use 'deactivate' if $(VENVDIR) is still activated"


pyLint: 
	$(PYTHON_LINT) src/*.py *.py
