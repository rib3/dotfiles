#!/usr/bin/env python

# Requires `github_token` command (not provided)

from urllib2 import Request, urlopen
from urllib import urlencode
from subprocess import check_output
import re
import json

TOKEN_BIN='github_token'

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

@validate("{} didn't return a token".format(TOKEN_BIN))
def github_token():
    try:
        return strip_output([TOKEN_BIN])
    except OSError as e:
        if e.errno == 2:
            raise Exception("{} command not found".format(TOKEN_BIN))
        raise

def request(path, query):
    url = "https://api.github.com{}".format(path)
    headers = { 'Authorization': ' '.join(["token", github_token()]) }
    url = '?'.join(filter(None, [url, urlencode(query)]))
    req = Request(url=url, headers=headers)
    return json.loads(urlopen(req).read())

def pulls(repo, query):
    path = "/repos/{}/pulls".format(repo_path())
    return request(path, query)
