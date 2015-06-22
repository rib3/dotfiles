#!/usr/bin/env python

# Requires `github_token` command (not provided)

from urllib2 import Request, urlopen
from urllib import urlencode
from misc import validate, strip_output
from git import *
import json
import re

__all__ = ('github_token', 'request', 'pulls', 'pull_request_id')

TOKEN_BIN='github_token'

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

def pull_request_id():
    query = { 'state': 'all', 'head': repo_branch_head() }
    data = pulls(repo_path(), query)
    for pr in data[:1]:
        return pr.get('number')
