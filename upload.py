#!/usr/bin/env python
import argparse
import logging
import os
import requests

API_URL = "http://localhost:8080"
R = lambda s: "\033[91m{}\033[0m".format(s)
G = lambda s: "\033[92m{}\033[0m".format(s)

def upload(filepath):
    url = API_URL + "/file/add"
    f = { "file": open(filepath, "rb") }
    res = requests.post(url, files=f)
    return res.ok

def main(args):
    for path in args.paths:
        if os.path.exists(path):
            for root, dirs, files in os.walk(path):
                for file in files:
                    fullpath = os.path.abspath(os.path.join(root, file))
                    if upload(fullpath):
                        print G("[+] {}".format(file))
                    else:
                        print R("[-] {}".format(file))

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("paths", nargs="+")
    args = parser.parse_args()

    main(args)
