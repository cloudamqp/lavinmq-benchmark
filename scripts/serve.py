#!/usr/bin/env python3
"""Serve results/ over HTTP with permissive CORS for local website previews.

The lavinmq-website benchmark charts page fetches JSON from a separate
origin, so a plain `python3 -m http.server` won't work — the browser
blocks the cross-origin request. This wrapper adds
`Access-Control-Allow-Origin: *` so the local Jekyll dev server
(http://localhost:4000) can fetch from http://localhost:8081.

Usage:
    python3 scripts/serve.py            # serves results/ on :8081
    python3 scripts/serve.py --port 9000
"""

from __future__ import annotations

import argparse
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

RESULTS = Path(__file__).resolve().parent.parent / "results"


class CORSRequestHandler(SimpleHTTPRequestHandler):
    def end_headers(self) -> None:
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Cache-Control", "no-store")
        super().end_headers()

    def do_OPTIONS(self) -> None:
        self.send_response(204)
        self.send_header("Access-Control-Allow-Methods", "GET, HEAD, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "*")
        self.end_headers()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--port", type=int, default=8081)
    parser.add_argument("--bind", default="127.0.0.1")
    args = parser.parse_args()

    handler = partial(CORSRequestHandler, directory=str(RESULTS))
    with ThreadingHTTPServer((args.bind, args.port), handler) as httpd:
        print(f"Serving {RESULTS} at http://{args.bind}:{args.port}/ (CORS *)")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print()


if __name__ == "__main__":
    main()
