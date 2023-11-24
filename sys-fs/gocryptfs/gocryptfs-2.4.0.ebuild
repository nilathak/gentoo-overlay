# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

SRC_URI="https://github.com/rfjakob/gocryptfs/releases/download/v${PV}/${PN}_v${PV}_src.tar.gz -> ${P}.tar.gz
	https://github.com/rfjakob/gocryptfs/releases/download/v${PV}/${PN}_v${PV}_src-deps.tar.gz"

DESCRIPTION="Encrypted overlay filesystem written in Go"
HOMEPAGE="https://nuetzlich.net/gocryptfs"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="debug libressl"

RDEPEND="
	sys-fs/fuse:0
	(
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
"

S="${WORKDIR}/${PN}_v${PV}_src-deps"

src_compile() {
	export GOPATH="${WORKDIR}"
	./build.bash || die
}

src_install() {
	dobin gocryptfs
	doman Documentation/gocryptfs.1
	use debug && dostrip -x /usr/bin/gocryptfs
}
