<#
  把演示素材推送到 GitHub 的一键脚本（PowerShell）
  用法：
    1. 先在 GitHub 网页上创建一个【公开(Public)】空仓库（不要勾选初始化 README）。
    2. 修改下面两个变量为你自己的用户名和仓库名。
    3. 在本文件所在目录打开 PowerShell，运行：  .\push_to_github.ps1
#>

$GitHubUser = "你的GitHub用户名"   # 例如：zhangsan
$RepoName   = "heu-heading-assets" # 例如：heu-heading-assets

if ($GitHubUser -like "*你的*" -or $GitHubUser -eq "") {
    Write-Host "请先修改脚本开头的 `$GitHubUser 和 `$RepoName！" -ForegroundColor Red
    exit 1
}

$repoUrl = "https://github.com/$GitHubUser/$RepoName.git"
Set-Location -Path $PSScriptRoot

# 1. 初始化 git 仓库（如果还没有）
if (-not (Test-Path ".git")) {
    git init
}

# 2. 默认分支用 main
git branch -M main

# 3. 添加远程仓库（幂等：先删后加）
git remote remove origin 2>$null
git remote add origin $repoUrl

# 4. 添加并提交全部文件
git add .
git commit -m "上传无人艇航向保持演示素材（12 PNG + 7 GIF）" 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "提交未产生变化（可能已是最新），继续推送..." -ForegroundColor Yellow
}

# 5. 推送到 GitHub main 分支
git push -u origin main

Write-Host ""
Write-Host "推送完成。Raw 链接前缀为：" -ForegroundColor Green
Write-Host "https://raw.githubusercontent.com/$GitHubUser/$RepoName/main/images/" -ForegroundColor Cyan
Write-Host ""
Write-Host "例如：https://raw.githubusercontent.com/$GitHubUser/$RepoName/main/images/control_block_diagram.png"
