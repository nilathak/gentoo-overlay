# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit latex-package

DESCRIPTION="dinbrief latex class."
SRC_URI="ftp://tug.ctan.org/tex-archive/macros/latex/contrib/${PN}.zip"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/dinbrief/"

RESTRICT="mirror"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="amd64"
IUSE="doc"

DEPEND="dev-texlive/texlive-latex
	app-arch/unzip
	"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_install() {

	latex-package_src_doinstall styles

	if use doc ; then
		dodoc *.pdf readme liesmich
	fi
}
