VENV_BIN = python3 -m venv
MODULE_DIR = telemc
VENV_DIR ?= .venv

VENV_ACTIVATE = . $(VENV_DIR)/bin/activate

all :
	@echo "select a build target"

venv: $(VENV_DIR)/bin/activate

$(VENV_DIR)/bin/activate: requirements.txt requirements-dev.txt
	test -d .venv || $(VENV_BIN) .venv
	$(VENV_ACTIVATE); pip install -Ur requirements.txt
	$(VENV_ACTIVATE); pip install -Ur requirements-dev.txt
	touch $(VENV_DIR)/bin/activate

clean:
	rm -rf build/
	rm -rf .eggs/
	find -iname "*.pyc" -delete
	rm -rf __pycache__
	find tests -type d -name "__pycache__" -delete
	find $(MODULE_DIR) -type d -name "__pycache__" -delete

clean-venv:
	rm -rf $(VENV_DIR)

clean-dist: clean
	rm -rf dist/
	rm -rf *.egg-info/

build: venv
	$(VENV_ACTIVATE); python setup.py build

test: venv
	$(VENV_ACTIVATE); python setup.py test

pytest: venv
	$(VENV_ACTIVATE); pytest --cov $(MODULE_DIR)/

dist: venv
	$(VENV_ACTIVATE); python setup.py sdist bdist_wheel

install: venv
	$(VENV_ACTIVATE); python setup.py install

deploy: venv test dist
	$(VENV_ACTIVATE); pip install --upgrade twine; twine upload dist/*

.PHONY: clean clean-dist clean-venv
