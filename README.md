# Clash WSL Network Fix

GitHub 网络急救箱 / WSL 网络修复工具

这是一个用于解决 **Clash + WSL 网络问题** 的诊断和修复工具。

支持：
- WSL 无法访问网络
- Clash 导致 WSL DNS 失效
- Windows / WSL 网络冲突
- 网络诊断与自动修复



1. 右键 `Clash_Network_Doctor_CN_deeptrace.ps1` -> 属性，在“常规”里把“解除锁定（来自其他计算机的文件）”勾选并应用。
![alt text](image.png)

2. 打开 `Clash Verge`。
进入“设置” -> “外部控制”。
![alt text](image-1.png)
在“外部控制器”中设置 API 密码并保存（用于防止未授权访问）。
![alt text](image-2.png)

3. 然后双击运行 `Run_Clash_Doctor.cmd` 即可。
第一次运行可能会提示输入 Clash API 密钥。

4. 主要功能（默认全部探测，不需要额外开关）
不会可以复制打印信息给gpt看，叫他帮你解决即可
会打印完整的运行证据、诊断解释和建议动作，重点不是“只看通不通”，而是定位“为什么有的软件能上、有的软件上不了”。

可探测并定位的问题包括：
1) DNS 解析异常（国内/国外/NCSI）
2) Clash 系统代理被覆盖、或仅浏览器走代理
3) WinHTTP / WinINET 分裂（部分程序不走 Clash）
4) WSL 网络问题（含是否安装、是否有发行版、联网模式、WSL 内 DNS/外网）
5) Microsoft Store 无法访问（关键域名 + 服务链）
6) TLS/证书风险（TLS1.2/1.3策略、微软登录站点 HTTPS 探测）
7) Windows 更新依赖服务异常（BITS/wuauserv/CryptSvc/UsoSvc/InstallService）
8) 防火墙/安全软件风险
9) Clash API 运行态深度信息：
   - 当前 mode（rule/global/direct）
   - Tun 是否启用
   - 当前策略组实际选择
   - 节点存活率
   - 活动连接和主出口链路（Dominant Path）

报告里重点看这些字段：
- `Network Path Verdict`：当前到底是 RULE / GLOBAL / DIRECT / TUN 接管
- `Clash Runtime DominantPath`：当前主要出口链路（例如 节点 > 策略组）
- `Clash Runtime DominantRate`：主要链路占比
- `WinHTTP Profile`：WinHTTP 是 Direct 还是代理
- `Microsoft Store` / `Store Probe Evidence`
- `WSL Network` / `NCSI Health` / `TLS/Cert` / `Update Chain`

5. 使用与测试注意

1) 命令行测试时，优先用 `curl` 做 HTTP/HTTPS 级别验证。
2) 不建议用 `ping www.google.com` 代替代理测试：
   - ping 走 ICMP，不代表应用层代理链路可用。
3) 如果某软件只走 WinHTTP，可能出现“浏览器正常、软件不通”：
   - 查看报告里的 `WinHTTP Profile`。
4) 首次需要 Clash API 密钥时会提示输入；成功后会保存，本机后续自动读取。
5) 你改了 API 密钥后，重新运行并输入新密钥即可覆盖旧值。
一个例子如：
![alt text](image-3.png)
