#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import subprocess
import re


def get_project_root():
    """Find the git root of project."""
    cmd = "git rev-parse --show-toplevel"
    try:
        return subprocess.check_output(cmd, shell=True)
    except subprocess.CalledProcessError:
        return None


def get_pwd():
    return subprocess.check_output("pwd", shell=True)


def replace_nonalphnum(string, replacement):
    return re.sub(r'[^A-Za-z0-9]+', replacement, string)
