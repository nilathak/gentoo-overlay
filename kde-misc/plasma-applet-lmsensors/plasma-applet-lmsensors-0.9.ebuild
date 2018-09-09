# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Plasma 5 applet for monitoring lmsensors"
HOMEPAGE="https://github.com/nilathak/plasma-applet-lmsensors"

if [[ ${KDE_BUILD_TYPE} = live ]] ; then
	EGIT_REPO_URI="https://github.com/nilathak/${PN}.git"

else
	SRC_URI="https://github.com/nilathak/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2+"
KEYWORDS="amd64"
IUSE=""

DEPEND="
	$(add_frameworks_dep plasma)
	$(add_plasma_dep plasma-workspace)
"
RDEPEND="${DEPEND}"

DOCS=( README.md )
