#!/usr/bin/env python

from subprocess import check_output
import re
import sys

__all__ = ('die', 'validate', 'strip_output', 'confirm')

def die(msg):
    if msg:
        print msg
    sys.exit(1)

def validate(msg):
    def decorator(func):
        def wrapper(*args, **kwargs):
            v = func(*args, **kwargs)
            if not v:
                raise Exception(msg)
            return v
        return wrapper
    return decorator

def strip_output(*args, **kwargs):
    return check_output(*args, **kwargs).strip()

def confirm(cmd):
    # using raw_input for now...
    answer = raw_input("run: {} [y/N] ".format(' '.join(cmd)))
    if re.match('^[yY]', answer):
        check_call(cmd)
        return True
