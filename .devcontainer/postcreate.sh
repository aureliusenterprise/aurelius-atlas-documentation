#!/bin/bash

git config --global --add safe.directory $PWD

poetry install --no-root

poetry run pre-commit install
