#!/usr/bin/env python

# Requires `github_token` command (not provided)

from misc import validate, strip_output
from urllib2 import Request, urlopen
from urllib import urlencode
from subprocess import check_call, check_output
import json
import re

__all__ = ('check_status', 'repo_branch', 'on_staging_branch', 'repo_path', 'repo_owner',
           'repo_branch_head', 'GitVersion')

def last_commit():
    return check_output(['git', 'log', '--format=%h', '-n', '1']).strip()

def check_status():
    try:
        check_call(['git', 'diff-files', '--quiet'])
    except:
        raise Exception('Git status dirty')

def commits_since_master():
    s = check_output(['git', 'rev-list', '--count', 'origin/master...HEAD']).strip()
    return int(s)

def dirty():
    try:
        check_status()
    except:
        return True

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

class GitVersion:
    def __init__(self):
        # I want the individual pieces, or else I'd use `git-describe`
        self.branch = repo_branch()
        self.commit = last_commit()
        self.count = commits_since_master()
        self._dirty = dirty()

    def dirty(self):
        if self._dirty:
            return 'dirty'

    def __str__(self):
        parts = [self.branch, str(self.count), self.commit, self.dirty()]
        return '-'.join(filter(None, parts))
