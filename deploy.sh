#!/bin/bash
# 微信H5电商 - 部署脚本

set -e  # 遇到错误退出

echo "🛒 微信H5电商 - 部署脚本"
echo "========================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 检查必要工具
check_tools() {
    echo "检查必要工具..."
    
    local missing_tools=()
    
    # 检查git
    if ! command -v git >/dev/null 2>&1; then
        missing_tools+=("git")
    else
        print_success "git 已安装"
    fi
    
    # 检查curl
    if ! command -v curl >/dev/null 2>&1; then
        missing_tools+=("curl")
    else
        print_success "curl 已安装"
    fi
    
    # 如果有缺失的工具
    if [ ${#missing_tools[@]} -gt 0 ]; then
        print_error "缺少必要工具: ${missing_tools[*]}"
        echo "请安装缺失的工具后重试"
        exit 1
    fi
    
    print_success "所有必要工具已安装"
}

# 创建Git仓库
setup_git() {
    echo "设置Git仓库..."
    
    # 初始化Git仓库
    if [ ! -d .git ]; then
        git init
        print_success "Git仓库初始化完成"
    else
        print_warning "Git仓库已存在"
    fi
    
    # 创建.gitignore
    cat > .gitignore << 'EOF'
# 依赖
node_modules/
__pycache__/
*.pyc

# 环境变量
.env
.env.local

# 日志
*.log
logs/

# 临时文件
*.tmp
*.temp

# 系统文件
.DS_Store
Thumbs.db

# IDE文件
.vscode/
.idea/
*.swp
*.swo

# 上传的文件
uploads/
EOF
    
    # 添加文件到Git
    git add .
    
    # 检查是否有更改
    if git status --porcelain | grep -q .; then
        git commit -m "初始提交: 微信H5电商网站" || true
        print_success "文件已提交到Git"
    else
        print_warning "没有需要提交的更改"
    fi
    
    print_success "Git设置完成"
}

# 显示部署选项
show_deploy_options() {
    echo ""
    echo "🎯 部署选项:"
    echo ""
    echo "1. GitHub Pages (推荐，免费)"
    echo "   - 最简单，完全免费"
    echo "   - 自动HTTPS"
    echo "   - 访问: https://用户名.github.io/仓库名/"
    echo ""
    echo "2. Vercel (免费，支持自定义域名)"
    echo "   - 部署速度快"
    echo "   - 自动SSL证书"
    echo "   - 全球CDN"
    echo ""
    echo "3. Netlify (免费，支持自定义域名)"
    echo "   - 类似Vercel"
    echo "   - 表单处理等功能"
    echo ""
    echo "4. 自有服务器"
    echo "   - 完全控制"
    echo "   - 需要技术维护"
    echo ""
}

# GitHub Pages部署指南
github_pages_guide() {
    echo ""
    echo "📱 GitHub Pages 部署指南:"
    echo ""
    echo "第一步: 创建GitHub仓库"
    echo "  1. 访问 https://github.com/new"
    echo "  2. 仓库名: wechat-shop (或其他名称)"
    echo "  3. 描述: 微信H5电商网站"
    echo "  4. 选择公开(Public)"
    echo "  5. 点击创建仓库"
    echo ""
    echo "第二步: 连接本地仓库"
    echo "  运行以下命令:"
    echo "  git remote add origin https://github.com/你的用户名/wechat-shop.git"
    echo "  git push -u origin main"
    echo ""
    echo "第三步: 启用GitHub Pages"
    echo "  1. 访问仓库设置: Settings → Pages"
    echo "  2. 分支: main"
    echo "  3. 文件夹: / (根目录)"
    echo "  4. 点击保存"
    echo ""
    echo "第四步: 访问网站"
    echo "  等待几分钟，然后访问:"
    echo "  https://你的用户名.github.io/wechat-shop/"
    echo ""
}

# Vercel部署指南
vercel_guide() {
    echo ""
    echo "⚡ Vercel 部署指南:"
    echo ""
    echo "第一步: 安装Vercel CLI"
    echo "  npm install -g vercel"
    echo ""
    echo "第二步: 登录Vercel"
    echo "  vercel login"
    echo ""
    echo "第三步: 部署"
    echo "  vercel"
    echo "  按照提示操作"
    echo ""
    echo "第四步: 生产环境部署"
    echo "  vercel --prod"
    echo ""
}

# Netlify部署指南
netlify_guide() {
    echo ""
    echo "🌐 Netlify 部署指南:"
    echo ""
    echo "第一步: 安装Netlify CLI"
    echo "  npm install -g netlify-cli"
    echo ""
    echo "第二步: 登录Netlify"
    echo "  netlify login"
    echo ""
    echo "第三步: 初始化项目"
    echo "  netlify init"
    echo ""
    echo "第四步: 部署"
    echo "  netlify deploy --prod"
    echo ""
}

# 自有服务器部署指南
self_hosted_guide() {
    echo ""
    echo "🖥️  自有服务器部署指南:"
    echo ""
    echo "第一步: 上传文件"
    echo "  使用FTP/SFTP/SCP上传所有文件到服务器"
    echo ""
    echo "第二步: 配置Web服务器"
    echo "  Nginx配置示例:"
    cat << 'NGINX_CONFIG'
server {
    listen 80;
    server_name your-domain.com;
    root /path/to/wechat_shop;
    index index.html;
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    # 启用gzip压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
}
NGINX_CONFIG
    echo ""
    echo "第三步: 配置SSL证书"
    echo "  使用Let's Encrypt免费证书:"
    echo "  certbot --nginx -d your-domain.com"
    echo ""
}

# 创建快速测试服务器
create_test_server() {
    echo ""
    echo "🔧 创建本地测试服务器..."
    
    cat > test_server.py << 'PYTHON_SERVER'
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
PYTHON_SERVER
    
    chmod +x test_server.py
    
    print_success "测试服务器脚本已创建: test_server.py"
    echo "运行: python3 test_server.py"
    echo "然后访问: http://localhost:8080"
}

# 主函数
main() {
    echo "开始部署微信H5电商网站..."
    echo ""
    
    # 检查工具
    check_tools
    
    # 设置Git
    setup_git
    
    # 显示部署选项
    show_deploy_options
    
    # 创建测试服务器
    create_test_server
    
    echo ""
    echo "🎉 部署准备完成！"
    echo ""
    echo "📋 下一步行动建议:"
    echo ""
    echo "1. 立即测试: 运行 python3 test_server.py"
    echo "2. 选择部署方案: 推荐GitHub Pages"
    echo "3. 按照指南部署"
    echo "4. 开始推广: 微信分享给朋友测试"
    echo ""
    echo "🛒 祝电商业务顺利！"
}

# 执行主函数
main "$@"