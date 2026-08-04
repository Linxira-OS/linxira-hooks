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
