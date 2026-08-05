#!/usr/bin/env python3
import http.server, functools, os, re

ROOT = os.path.dirname(os.path.abspath(__file__))

REDIRECTS = []
for line in open(os.path.join(ROOT, "_redirects"), encoding="utf-8"):
    line = line.strip()
    if not line or line.startswith("#"):
        continue
    parts = line.split()
    if len(parts) >= 3:
        REDIRECTS.append((parts[0], parts[1], int(parts[2])))

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *a, **kw):
        super().__init__(*a, directory=ROOT, **kw)

    def resolve(self, path):
        path = path.split("?")[0]
        for src, dest, status in REDIRECTS:
            if src == path or re.fullmatch(src, path):
                return dest, status
        return path, 200

    def do_GET(self):
        dest, status = self.resolve(self.path)
        if dest.startswith(("http", "//")):
            self.send_response(302)
            self.send_header("Location", dest)
            self.end_headers()
            return
        fragment = ""
        if "#" in dest:
            dest, fragment = dest.split("#", 1)
        rel = dest.lstrip("/")
        if not os.path.isfile(os.path.join(ROOT, rel)):
            self.send_error(404, f"{dest} not found")
            return
        super().send_response(status)
        if status == 301:
            self.send_header("Location", dest + fragment)
        super().send_header("Content-type", self.guess_type(rel))
        self.end_headers()
        with open(os.path.join(ROOT, rel), "rb") as f:
            self.wfile.write(f.read())

    def end_headers(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        super().end_headers()

if __name__ == "__main__":
    print(f"Redirects loaded: {len(REDIRECTS)}")
    http.server.ThreadingHTTPServer(("0.0.0.0", 8080), Handler).serve_forever()
