#!/usr/bin/env python3
"""
微信H5电商 - 本地测试服务器
运行: python3 test_server.py
访问: http://localhost:8080
"""

import http.server
import socketserver
import os
import webbrowser

PORT = 8080

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=os.path.dirname(__file__), **kwargs)
    
    def end_headers(self):
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        super().end_headers()

def main():
    print("🛒 微信H5电商 - 本地测试服务器")
    print(f"访问: http://localhost:{PORT}")
    print("按 Ctrl+C 停止服务器")
    
    try:
        webbrowser.open(f'http://localhost:{PORT}')
    except:
        pass
    
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n服务器已停止")

if __name__ == "__main__":
    main()
