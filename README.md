# Openwrt-BuilderX

基于 [ImmortalWrt](https://github.com/immortalwrt/immortalwrt) 的 GitHub Actions 固件编译仓库，支持以下设备：

| 预设 | 设备 | 目标 |
|------|------|------|
| `mt2500` | GL.iNet GL-MT2500 (Airoha) | MediaTek Filogic |
| `mt6000` | GL.iNet GL-MT6000 | MediaTek Filogic |
| `easepi` | 易微联 EasePi R1 | Rockchip RK3568 |

软件包均来自 ImmortalWrt 官方 feed（`packages`、`luci` 等），**不追加第三方 feed**。

## 使用方法

1. 在 GitHub 仓库 **Actions** 页面选择 **Build OpenWrt**。
2. 点击 **Run workflow**，选择目标设备（`mt2500` / `mt6000` / `easepi`）。
3. 可选：修改 ImmortalWrt 分支（默认 `openwrt-25.12`）。默认会发布到 **GitHub Release**。
4. 编译成功后下载固件：
   - **Actions Artifacts**（推荐）：打开该次 workflow run 页面，**滚到最底部** → **Artifacts** → 下载 `firmware-<device>-<时间戳>.zip`
   - **GitHub Releases**：仓库 **Releases** 页，附件中含 `FLASH-*` 或 `*sysupgrade.img.gz` / `*sysupgrade.bin`
   - EasePi 刷机文件：`*-sysupgrade.img.gz`；MT2500/MT6000：`*-sysupgrade.bin`

## 目录结构

```
configs/                  # 各设备 .config 预设
  mt2500.config
  mt6000.config
  easepi.config
  default.packages.txt    # 共用额外软件包清单（ImmortalWrt 官方源内）
scripts/ci/
  devices/                # 设备专属配置微调
  patches/                # 源码补丁（如 EasePi rkbin hash）
```

## 自定义

- **修改软件包**：编辑 `configs/default.packages.txt`，然后运行 `scripts/ci/apply-default-packages.sh <device>` 重新生成对应 `.config`（需在 ImmortalWrt 源码树内执行）。
- **设备专属设置**：在 `scripts/ci/devices/<device>.sh` 中添加 sed / 补丁逻辑。

## Credits

- [ImmortalWrt](https://github.com/immortalwrt/immortalwrt)
- [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)（原始模板）

## License

[MIT](LICENSE)
