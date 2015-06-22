#!/usr/bin/env python

# Requires `github_token` command (not provided)

from urllib2 import Request, urlopen
from urllib import urlencode
from misc import validate, strip_output
import json
import re

__all__ = ('repo_branch', 'repo_path', 'repo_owner', 'repo_branch_head')

@validate('Unable to determine branch name')
def repo_branch():
    return strip_output(['git', 'rev-parse', '--abbrev-ref', 'HEAD'])

@validate('Unable to determine repository path')
def repo_path():
    url = strip_output(['git', 'config', '--get', 'remote.origin.url'])
    if not url:
        raise Exception('No git remote')
    path = url.split(':')[-1]
    no_git = re.sub('\.git$', '', path)
    return no_git

@validate('Unable to determine repo owner')
def repo_owner():
    return repo_path().split('/')[0]

def repo_branch_head():
    return ':'.join([repo_owner(), repo_branch()])
