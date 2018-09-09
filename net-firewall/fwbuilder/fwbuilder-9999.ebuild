# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils autotools

DESCRIPTION="A firewall GUI"
HOMEPAGE="http://www.fwbuilder.org/"
if [[ ${PV} == 9999* ]]
then
	EGIT_REPO_URI="https://github.com/fwbuilder/fwbuilder"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/UNINETT/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc64 ~x86"
fi
RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
IUSE="libressl"

DEPEND="
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	dev-libs/elfutils
	>=dev-qt/qtgui-5.5.1-r1:5"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	sed -i -e '/dnl.*AM_INIT_AUTOMAKE/d' configure.in || die #398743
	mv configure.in configure.ac || die #426262
	eautoreconf
}

src_configure() {
	eqmake5
	# portage handles ccache/distcc itself
	econf --without-{ccache,distcc}
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst() {
	validate_desktop_entries

	elog "You need to emerge sys-apps/iproute2"
	elog "in order to run the firewall script."
}