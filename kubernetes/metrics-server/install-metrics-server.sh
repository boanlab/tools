#!/bin/bash

kubectl apply -f "$(dirname "$0")/metrics-server.yaml"
