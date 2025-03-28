#!/bin/bash

{ eval $(ssh-agent -s) && ssh-add ~/.ssh/wg.github; }
