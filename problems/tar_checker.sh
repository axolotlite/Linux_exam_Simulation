#!/bin/bash
DIR="var/tmp/"
#i'm unsure how to do this correctly, so for the mean time i'll do it simply

tar -tf test.tar.gz | grep ".verification" && echo archive success || echo archive failure
