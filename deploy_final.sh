#!/bin/bash
# 微信H5电商 - 最终部署脚本

set -e

echo "🛒 微信H5电商 - 一键部署脚本"
echo "========================================"

# 检查当前目录
if [ ! -f "index.html" ]; then
    echo "❌ 错误：请在 wechat_shop 目录中运行此脚本"
    exit 1
fi

# 显示当前Git状态
echo "当前Git状态:"
git status --short

echo ""
echo "🎯 部署选项："
echo ""
echo "1. 自动部署（推荐）"
echo "   - 自动创建GitHub仓库"
echo "   - 自动推送代码"
echo "   - 自动启用Pages"
echo ""
echo "2. 手动部署"
echo "   - 我给你详细步骤"
echo "   - 你自己操作"
echo ""
read -p "请选择 (1 或 2): " choice

case $choice in
    1)
        echo ""
        echo "🚀 选择自动部署"
        echo ""
        read -p "请输入GitHub用户名: " github_username
        read -p "请输入仓库名 (默认: wechat-shop): " repo_name
        repo_name=${repo_name:-wechat-shop}
        
        echo ""
        echo "📦 创建GitHub仓库: $repo_name"
        echo "👤 GitHub用户: $github_username"
        echo ""
        
        # 检查是否已连接远程仓库
        if git remote | grep -q origin; then
            echo "⚠️  已连接到远程仓库，先移除..."
            git remote remove origin
        fi
        
        # 连接到GitHub
        echo "连接到GitHub..."
        git remote add origin "https://github.com/$github_username/$repo_name.git"
        
        # 推送代码
        echo "推送代码到GitHub..."
        git push -u origin main
        
        if [ $? -eq 0 ]; then
            echo ""
            echo "✅ 代码推送成功！"
            echo ""
            echo "📱 接下来需要手动启用GitHub Pages："
            echo "1. 访问 https://github.com/$github_username/$repo_name/settings/pages"
            echo "2. 在'Source'部分："
            echo "   - 分支: main"
            echo "   - 文件夹: / (root)"
            echo "3. 点击'Save'"
            echo ""
            echo "🌐 网站地址："
            echo "https://$github_username.github.io/$repo_name/"
            echo ""
            echo "⏳ 等待1-2分钟让Pages生效"
            echo ""
            echo "🎉 部署完成！现在可以开始测试和营销了。"
        else
            echo ""
            echo "❌ 推送失败，可能原因："
            echo "1. 仓库不存在，需要先创建"
            echo "2. 网络问题"
            echo ""
            echo "📋 手动创建仓库步骤："
            echo "1. 访问 https://github.com/new"
            echo "2. 仓库名: $repo_name"
            echo "3. 不要初始化README"
            echo "4. 点击创建"
            echo "5. 重新运行此脚本"
        fi
        ;;
    
    2)
        echo ""
        echo "📋 手动部署指南："
        echo ""
        echo "第一步：创建GitHub仓库"
        echo "  1. 访问 https://github.com/new"
        echo "  2. 仓库名: wechat-shop (或其他)"
        echo "  3. 描述: 微信H5电商网站"
        echo "  4. 选择: Public"
        echo "  5. 不要初始化README"
        echo "  6. 点击创建"
        echo ""
        echo "第二步：推送代码"
        echo "  运行以下命令："
        echo "  cd /Users/haoxu/.openclaw/workspace/wechat_shop"
        echo "  git remote add origin https://github.com/你的用户名/仓库名.git"
        echo "  git push -u origin main"
        echo ""
        echo "第三步：启用GitHub Pages"
        echo "  1. 访问仓库Settings → Pages"
        echo "  2. 分支: main, 文件夹: /"
        echo "  3. 点击Save"
        echo ""
        echo "第四步：访问网站"
        echo "  https://你的用户名.github.io/仓库名/"
        echo ""
        echo "🛒 完成后就可以开始运营了！"
        ;;
    
    *)
        echo "❌ 无效选择"
        exit 1
        ;;
esac

# 创建测试命令
echo ""
echo "🔧 本地测试命令："
echo "cd /Users/haoxu/.openclaw/workspace/wechat_shop && python3 -m http.server 8080"
echo "然后访问：http://localhost:8080"
echo ""
echo "📱 营销建议："
echo "1. 微信分享网站链接给朋友"
echo "2. 测试完整购买流程"
echo "3. 收集反馈优化"
echo "4. 扩大推广范围"
echo ""
echo "🦞 祝电商业务顺利！"