# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd
inherit git-r3

DESCRIPTION="A sophisticated low memory handler for Linux"
HOMEPAGE="https://github.com/hakavlad/nohang"
LICENSE="MIT"
SLOT="0"
IUSE="systemd"

EGIT_REPO_URI="https://github.com/hakavlad/nohang"
if [ "${PV}" = "9999" ]; then
	EGIT_BRANCH="dev"
	EGIT_COMMIT=""
else
	EGIT_COMMIT="${PV}"
	KEYWORDS="~amd64 ~x86"
fi

DEPEND="dev-lang/python
	app-admin/sudo
	systemd? ( sys-apps/systemd )
	"
RDEPEND="${DEPEND}
	x11-libs/libnotify"
BDEPEND=""

S="${WORKDIR}"/"${P}"

src_install() {
	if use systemd; then
		PREFIX="/usr" SYSCONFDIR="/etc" emake DESTDIR="${D}" install
	else
		PREFIX="/usr" SYSCONFDIR="/etc" emake DESTDIR="${D}" -B install-openrc
	fi

	# fix permissions
	chmod g-w "${ED}"/etc/init.d/nohang* || die
}
