# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="gLabels label designer (now in Qt6)."
HOMEPAGE="https://github.com/j-evins/glabels-qt"

# Latest tag as of now (complete Qt6 port)
MY_PV="3.99-master618"
SRC_URI="https://github.com/j-evins/glabels-qt/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~x86"

IUSE="barcode qrcode zlib"

DEPEND="
	zlib? ( sys-libs/zlib )
	barcode? ( app-text/barcode )
	qrcode? ( dev-libs/qrencode )
	dev-qt/qtbase:6[concurrent,gui,widgets,xml]
	dev-qt/qtsvg:6
"
RDEPEND="${DEPEND}"

BDEPEND="dev-qt/qttools:6[linguist]"

S="${WORKDIR}/glabels-qt-${MY_PV}"

src_prepare() {
	# Remove Qt5Test / Qt6Test leftovers, LibZint (not in Gentoo main tree),
	# and the "Test" component from the Qt6 find_package call.
	sed -r \
		-e '/find_package \(Qt[0-9]*Test.*/d' \
		-e '/find_package \(LibZint.*/d' \
		-e 's/ Test([[:space:]]*$|)/\1/' \
		-i CMakeLists.txt || die

	# Make the optional dependencies conditional (exactly as upstream supports)
	! use zlib && {
		sed -r -e '/find_package \(ZLIB.*/d' -i CMakeLists.txt || die
	}
	! use barcode && {
		sed -r -e '/find_package \(GnuBarcode.*/d' -i CMakeLists.txt || die
	}
	! use qrcode && {
		sed -r -e '/find_package \(LibQrencode.*/d' -i CMakeLists.txt || die
	}

	cmake_src_prepare
}

src_install() {
	cmake_src_install

	# Obsolete appdata directory (upstream switched to metainfo)
	rm -rf "${D}/usr/share/appdata" 2>/dev/null || true

	einstalldocs
}
