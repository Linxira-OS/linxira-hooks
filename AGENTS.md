# linxira-hooks · Agent 开发规范

> **档位**:A · 系统源仓
> **本仓职责**:面向 Linxira OS 的 Pacman hooks 与辅助脚本,用于系统标识与维护;
> 以 root 级 ALPM hook 形式在包操作期间自动运行。
> 通用约束见工作区总纲 `f:\Linxira-OS\AGENTS.md` 与发布规范 `linxira-os/docs/RELEASE_STANDARD.md`;
> 本文只写本仓特有内容。

## 职责与边界

- **仅用 Bash**,除 `bash` 外无运行时依赖;**幂等**(重生成 os-release/lsb-release 可安全重复运行)。
- Hook 与脚本对应关系:

  | Hook | 触发 | 效果 |
  |---|---|---|
  | `linxira-os-release.hook` | 任意包安装/升级/删除 | 以当前品牌信息重生成 `/usr/lib/os-release`(`linxira-branding`) |
  | `linxira-lsb-release.hook` | 任意包安装/升级/删除 | 从 os-release 重生成 `/etc/lsb-release` |
  | `linxira-reboot-required.hook` | 内核/glibc/systemd/驱动升级 | 写 reboot 标记 `/var/lib/linxira/reboot-required` |
  | `linxira-plymouth-initramfs.hook` | initramfs 相关包变更 | 重生成 initramfs,保住 Plymouth 动画(`linxira-update-initramfs`) |

- 安装的辅助脚本:`/usr/share/libalpm/scripts/linxira-branding`、`/usr/share/libalpm/scripts/linxira-reboot-required`、
  `/usr/bin/linxira-update-initramfs`;另装 `linxira-reboot-required-clear.service`(`/usr/lib/systemd/system/`)。
- **仅供只读工具消费 reboot 状态**:`linxira-reboot-required.hook` 只写标记文件,**从不强制重启**;
  该标记由 `linxira-welcome` 等只读工具读取以提示重启。

## 目录布局

- Hook 文件:`linxira-os-release.hook`、`linxira-lsb-release.hook`、`linxira-reboot-required.hook`、
  `linxira-plymouth-initramfs.hook`
- 脚本:`linxira-branding`、`linxira-reboot-required`、`linxira-update-initramfs`
- 单元:`linxira-reboot-required-clear.service`
- **本仓根目录自带 `PKGBUILD`**(与多数源仓不同)

## 本地校验

```sh
for f in *.hook; do bash -n "$f"; done   # CI 对全部 hook 做语法检查(分支 main / master)
```

打包(产出 `linxira-hooks` 包,随官方签名 `[linxira]` 仓库分发):

```sh
makepkg -f
```

## 版本与发布

- 版本唯一来源是本仓根 `VERSION`(当前 `1.1.0`);**`PKGBUILD` 的 `pkgver` 必须与其同步**。
- `PKGBUILD` 用 **git source**(`source=("$pkgname-$pkgver.tar.gz")`,`sha256sums=('SKIP')`)。
- 改 `VERSION` 触发 `.github/workflows/release.yml`(分支 `master`)自动建 Release,进入 `[linxira]` 全自动链。**禁止手工 bump**。

## 禁区

- `PKGBUILD` 与 `.sh` / hook 必须 **LF 行尾**(makepkg 解析需要)。
- 不引入 `cachyos` / `aur` / `seafoam` 仓库引用;不改动 `sha256sums=('SKIP')` 的 git source 逻辑。
- hook 为 root 级 ALPM:必须幂等,`reboot-required` 只写标记、不得强制重启,不得引入额外运行时依赖。
- 提权只走 `linxira-components` + polkit(不直接 `sudo`/`su`/`doas`/`run0`);不 `git add -A`。