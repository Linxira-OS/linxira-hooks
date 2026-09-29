# Linxira Hooks

Pacman hooks and helper scripts for Linxira OS system identification and
maintenance. Installed as root-level ALPM hooks, they run automatically during
package operations so the system always reflects the installed packages.

## What it does

| Hook / script | Trigger | Effect |
|---|---|---|
| `linxira-os-release.hook` | any package install/upgrade/remove | Regenerates `/usr/lib/os-release` with the current Linxira branding (`linxira-branding`) |
| `linxira-lsb-release.hook` | any package install/upgrade/remove | Regenerates `/etc/lsb-release` from the current os-release |
| `linxira-reboot-required.hook` | kernel, glibc, systemd, or driver upgrades | Writes a reboot-required marker (`/var/lib/linxira/reboot-required`) so tools like Linxira Welcome can flag it |
| `linxira-plymouth-initramfs.hook` | initramfs-relevant package changes | Regenerates the initramfs so the Plymouth boot animation is preserved (`linxira-update-initramfs`) |

Helper scripts installed:

- `/usr/share/libalpm/scripts/linxira-branding` — os-release / lsb-release generator
- `/usr/share/libalpm/scripts/linxira-reboot-required` — reboot marker logic
- `/usr/bin/linxira-update-initramfs` — initramfs regeneration (mkinitcpio)

## Why this matters

Linxira is a Direct Arch workstation: package updates come from Arch
repositories plus the signed `[linxira]` repository. These hooks keep the
system-identification files consistent with whatever is actually installed,
and make sure a kernel or graphics driver update never leaves the system
without a working initramfs and boot animation.

## Design notes

- **Bash only** — matches the rest of the low-level system tooling; no runtime
  dependencies beyond `bash`.
- **Idempotent** — regenerating os-release/lsb-release is safe to run any
  number of times.
- **Marker over mutating** — `reboot-required` only writes a marker file; it
  never forces a reboot.
- The reboot-required marker is consumed by read-only tools (e.g. Linxira
  Welcome) to show a restart hint after upgrades.

## Packaging

Built with `makepkg` from this repository. The resulting `linxira-hooks`
package ships in the official signed `[linxira]` repository.

```bash
makepkg -f
```

## License

GPL-3.0-or-later. See the `PKGBUILD` license field.

---

## 简体中文

面向 Linxira OS 的 Pacman 钩子与辅助脚本，用于系统标识与系统维护。它们以
root 级 ALPM 钩子形式安装，在软件包操作期间自动运行，使系统标识始终反映
实际安装的软件包。

### 功能

| 钩子 / 脚本 | 触发条件 | 效果 |
|---|---|---|
| `linxira-os-release.hook` | 任何软件包安装/升级/删除 | 以当前 Linxira 品牌信息重新生成 `/usr/lib/os-release`（`linxira-branding`） |
| `linxira-lsb-release.hook` | 任何软件包安装/升级/删除 | 从当前 os-release 重新生成 `/etc/lsb-release` |
| `linxira-reboot-required.hook` | 内核、glibc、systemd 或驱动升级 | 写入 reboot-required 标记（`/var/lib/linxira/reboot-required`），供 Linxira Welcome 等工具提示 |
| `linxira-plymouth-initramfs.hook` | initramfs 相关软件包变更 | 重新生成 initramfs，保持 Plymouth 开机动画（`linxira-update-initramfs`） |

安装的辅助脚本：

- `/usr/share/libalpm/scripts/linxira-branding` — os-release / lsb-release 生成器
- `/usr/share/libalpm/scripts/linxira-reboot-required` — 重启标记逻辑
- `/usr/bin/linxira-update-initramfs` — initramfs 重新生成（mkinitcpio）

### 为什么重要

Linxira 是 Direct Arch 工作站：软件包更新来自 Arch 仓库加上签名的 `[linxira]`
仓库。这些钩子保证系统标识文件与实际安装内容一致，并确保内核或显卡驱动更新
之后系统始终拥有可用的 initramfs 与开机动画。

### 设计说明

- **仅用 Bash** — 与其余底层系统工具保持一致；除 `bash` 外无运行时依赖。
- **幂等** — 重新生成 os-release/lsb-release 可安全重复运行。
- **标记而非强制** — `reboot-required` 只写标记文件，从不强制重启。
- 重启标记由只读工具（如 Linxira Welcome）消费，在升级后显示重启提示。

### 打包

使用 `makepkg` 从本仓库构建。产出的 `linxira-hooks` 包发布在官方签名的
`[linxira]` 仓库中。

```bash
makepkg -f
```

### 许可证

GPL-3.0-or-later。见 `PKGBUILD` 的 license 字段。
