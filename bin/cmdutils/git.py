#!/usr/bin/env python

# Requires `github_token` command (not provided)

from misc import validate, strip_output
from urllib2 import Request, urlopen
from urllib import urlencode
from subprocess import check_call, check_output
import json
import re

__all__ = ('check_status', 'repo_branch', 'on_staging_branch', 'repo_path', 'repo_owner', 'repo_branch_head')

def check_status():
    try:
        check_call(['git', 'diff-files', '--quiet'])
    except:
        raise Exception('Git status dirty')

@validate('Unable to determine branch name')
def repo_branch():
    return strip_output(['git', 'rev-parse', '--abbrev-ref', 'HEAD'])

def on_staging_branch():
    return re.match('^staging\.', repo_branch())

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
