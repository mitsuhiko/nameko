# See https://bugs.launchpad.net/pyflakes/+bug/1223150
export PYFLAKES_NODOCTEST=1

noop:
	@true

.PHONY: noop

requirements:
	pip install -r dev_requirements.txt -q

develop: requirements
	python setup.py -q develop

pytest:
	coverage run --concurrency=eventlet --source nameko -m pytest test

flake8:
	flake8 nameko test

pylint:
	pylint nameko -E

test: flake8 pylint pytest coverage-check

full-test: requirements test

coverage-check:
	coverage report --fail-under=100

sphinx: develop
	sphinx-build -b html -d docs/build/doctrees docs docs/build/html

docs/modules.rst: $(wildcard nameko/*.py) $(wildcard nameko/**/*.py)
	sphinx-apidoc -e -f -o docs nameko

autodoc: docs/modules.rst

docs: autodoc sphinx
