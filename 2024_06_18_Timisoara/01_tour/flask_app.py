#!/usr/bin/env python3

"""
Simple Flask app which lists/cats directories/files on the host.

Prerequisites on Ubuntu 22.04:
    - apt install -y python3 python3-pip
    - pip3 install Flask

Args and examples:
    - python3 /path/to/the/flask_app.py LISTEN_ON_HOST LISTEN_ON_PORT
    - python3 flask_app.py localhost 8080
    - python3 flask_app.py 10.7.2.3 9000
    - python3 flask_app.py 0.0.0.0 9192
"""

import json, os, sys
import flask

# Declare Flask app:
app = flask.Flask(__name__)

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def get_dirpath(path):
    path = f"/{path}"
    if os.path.isdir(path):
        # List entries within directories:
        return json.dumps(sorted(os.listdir(path)), indent=4)
    elif os.path.isfile(path):
        # Return contents of files:
        with open(path, "r") as fin:
            return fin.read()
    else:
        # 404 if the path is a link or does not exist:
        flask.abort(404)

if __name__ == "__main__":
    print(f"sys.argv were: {sys.argv}")
    if len(sys.argv) < 3:
        raise ValueError(
            f"USAGE: python3 {sys.argv[0]} LISTEN_ON_HOST LISTEN_ON_PORT")
    hostname = sys.argv[1]
    port = int(sys.argv[2])

    app.run(hostname, port)
