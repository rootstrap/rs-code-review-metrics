#!/bin/sh

psql -c 'create database code_review_metrics_development;' -U postgres
psql -U postgres -q -d code_review_metrics_development -f db/structure.sql
cp -f config/travis/database.yml config/database.yml