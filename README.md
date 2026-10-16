# PC Setup

新电脑一键安装 Claude Desktop + Windows-MCP 需要的工具：

- **Python 3.13**
- **uv**
- **FFmpeg**（视频剪辑用）

已经装过的会自动跳过。

## 用法

### 方法 1：一行命令（推荐）

开始菜单搜索 **PowerShell**，打开后粘贴运行：

```powershell
irm https://raw.githubusercontent.com/cst0214/pc-setup/main/setup.ps1 | iex
```

### 方法 2：下载后双击

点页面上的 **Code → Download ZIP**，解压后双击 **setup.bat**。

## 装完以后

1. 完全退出 Claude Desktop（右下角托盘图标 → Quit），再重新打开。
2. **Settings → Extensions**，搜索 **Windows-MCP**，点 **Install**。
