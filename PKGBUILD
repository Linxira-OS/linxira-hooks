# Maintainer: Linxira OS <admin@linxira.org>

pkgname=linxira-hooks
pkgver=1.1.0
pkgrel=1
pkgdesc="Pacman hooks for Linxira OS system identification and reboot tracking"
arch=('any')
url="https://github.com/Linxira-OS/linxira-hooks"
license=('GPL-3.0-or-later')
depends=('bash' 'systemd')

source=("$pkgname-$pkgver.tar.gz")
sha256sums=('SKIP')

package() {
    cd "$srcdir/$pkgname-$pkgver"

    install -Dm755 linxira-branding "$pkgdir/usr/share/libalpm/scripts/linxira-branding"
    install -Dm755 linxira-reboot-required "$pkgdir/usr/share/libalpm/scripts/linxira-reboot-required"
    install -Dm755 linxira-update-initramfs "$pkgdir/usr/bin/linxira-update-initramfs"

    install -Dm644 linxira-os-release.hook "$pkgdir/usr/share/libalpm/hooks/linxira-os-release.hook"
    install -Dm644 linxira-lsb-release.hook "$pkgdir/usr/share/libalpm/hooks/linxira-lsb-release.hook"
    install -Dm644 linxira-reboot-required.hook "$pkgdir/usr/share/libalpm/hooks/linxira-reboot-required.hook"
    install -Dm644 linxira-plymouth-initramfs.hook "$pkgdir/usr/share/libalpm/hooks/linxira-plymouth-initramfs.hook"

    install -Dm644 linxira-reboot-required-clear.service \
        "$pkgdir/usr/lib/systemd/system/linxira-reboot-required-clear.service"
}

post_install() {
    systemctl enable linxira-reboot-required-clear.service
}

post_upgrade() {
    systemctl enable linxira-reboot-required-clear.service
}
