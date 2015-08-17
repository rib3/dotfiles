#!/usr/bin/env python

from tempfile import NamedTemporaryFile
from subprocess import check_call, check_output
import re

__all__ = ('mysql_table_name', 'mysql_copy_db')

def mysql_table_name(s):
    return re.sub('[-.]', '_', s)

def mysql_args(args):
    return ['-u', 'root']

def mysql(mysql_args, *args, **kwargs):
    cmd = ['mysql', '-u', 'root'] + list(mysql_args)
    return check_call(cmd, *args, **kwargs)

def mysql_copy_db(old, new):
    print "copy: {} -> {}".format(old, new)
    mysql(['-e', 'CREATE DATABASE {}'.format(new)])
    dump = NamedTemporaryFile(suffix='.sql', delete=False)
    print "file: {}".format(dump.name)
    check_call(['mysqldump', '-u', 'root', old], stdout=dump)
    dump.flush()
    dump.seek(0)
    mysql([new], stdin=dump)
