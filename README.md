# Clash Network Doctor (Windows + Clash + WSL)
clash网络急救箱网络诊断器/wsl网络急救箱网络诊断器
当前版本：`1.4.0`

## 目录约定
- 外层目录：开发目录（当前目录）
- 内层目录：发布目录（单独维护）


## 用途


可以得到非常详细的网络排查日志，包含大量专业信息。

和一个可以快速看的诊断解释。

对于需要快速看到问题的开发者，或者疑难症状的解决都非常有帮助
仅仅需要拷贝打印信息，上传给ai看，自然ai会教你针对这个网络环境怎么处理的
![alt text](image-3.png)



## 快速开始
1. 右键 `Clash_Network_Doctor_CN_deeptrace.ps1` -> 属性，在“常规”里把“解除锁定（来自其他计算机的文件）”勾选并应用。  
![alt text](image.png)
2. 打开 `Clash Verge` -> 设置 -> 外部控制，在“外部控制器”中设置 API 密码并保存。  
![alt text](image-1.png)  
![alt text](image-2.png)
3. 双击运行 `Run_Clash_Doctor.cmd`。首次运行可能会提示输入 Clash API 密钥。

## 自动化模式
- 无交互运行（不等待按回车）：
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Clash_Network_Doctor_CN_deeptrace.ps1 -NoPause
```
- 通过启动器传参：
```cmd
Run_Clash_Doctor.cmd -NoPause -NoSecretPrompt
```

## 开发目录说明
- 外层目录是开发目录，允许继续演进代码、文档、构建脚本和回归清单。
- 内层 `Clash_Network_Doctor/` 是发布目录，开发时不要直接改它。
- 当前开发目录新增了：
  - `src/`：面向后续拆分维护的源码片段目录
  - `tools/build-release.ps1`：生成单文件发布脚本的构建脚本
  - `docs/REGRESSION_CHECKLIST.md`：回归检查清单

## 开发/构建命令
- 仅验证 build pipeline：
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\build-release.ps1 -ValidateOnly
```
- 生成单文件构建产物到 `build/`：
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\build-release.ps1
```
- 基础 smoke run：
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Clash_Network_Doctor_CN_deeptrace.ps1 -NoPause -NoSecretPrompt
```

## 退出码规范
- `0`：SUCCESS（核心链路通过）
- `10`：PARTIAL（可用但存在风险或部分异常）
- `20`：FAIL（核心链路失败）
- `30`：RUNTIME_ERROR（运行时错误，如报告写入失败）

报告文件中会新增 `[RESULT]` 段，包含 `ExitCode` / `ExitCategory`。

## 主要探测范围
1. DNS（国内/国外/NCSI）
2. Clash 系统代理覆盖情况
3. WinHTTP / WinINET 分裂
4. WSL（安装、发行版、网络模式、WSL 内 DNS/外网）
5. Microsoft Store 访问链路
6. TLS/证书风险
7. Windows Update 依赖服务
8. 防火墙/安全软件风险
9. Clash API 运行态（mode、Tun、策略组、节点存活、主出口链路）
10. WSL 直连 / 代理 HTTPS 对比
11. WSL AI 开发连通性（PyPI / HuggingFace / GitHub / Conda / Ubuntu Repo）
12. WSL GitHub `git ls-remote` 工具链测试
13. MTU 风险提示（启发式）

## 报告重点字段
- `Network Path Verdict`
- `Clash Runtime DominantPath`
- `Clash Runtime DominantRate`
- `WinHTTP Profile`
- `Microsoft Store` / `Store Probe Evidence`
- `WSL Network` / `NCSI Health` / `TLS/Cert` / `Update Chain`
- `WSL HTTP Direct` / `WSL HTTP Proxy`
- `AI Direct` / `AI Proxy` / `WSL Git`
- 报告中的 `[AI_DEVELOPMENT]` 段

## 使用注意
1. 代理连通优先看 `curl` 的 HTTP/HTTPS 证据，不要只看 `ping`。
2. 浏览器正常但某些软件不通时，重点看 `WinHTTP Profile`。
3. Clash API 密钥会本机加密保存；变更密钥后重新输入即可覆盖。
4. AI 开发场景下，不建议脚本自动切换最近镜像；当前仅做测速、诊断和建议。
5. 若 WSL 直连失败但代理成功，优先考虑给 WSL shell、pip、git、conda 显式配置代理。

示例：
![alt text](image-3.png)
