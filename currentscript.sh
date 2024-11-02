#!/bin/bash

Course="DevOps from current script" 
echo "Before calling other script:$Course"
echo "PID of current script:$$"

#./otherscript.sh
source ./otherscript.sh
echo "After calling other script:$Course"
