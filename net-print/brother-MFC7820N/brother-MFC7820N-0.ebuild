# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib rpm

DESCRIPTION="Brother MFC7820N linux drivers"
HOMEPAGE="http://www.brother.com/"

RESTRICT="mirror"

SRC_URI="
	http://download.brother.com/welcome/dlf006267/cupswrapperMFC7820N-2.0.1-1.i386.rpm
	http://download.brother.com/welcome/dlf006265/brmfc7820nlpr-2.0.1-1.i386.rpm
	http://download.brother.com/welcome/dlf006640/brscan2-0.2.5-1.x86_64.rpm
"

SLOT="0"
KEYWORDS="amd64"
IUSE=""

LICENSE="GPL-2"
DEPEND=""

# following files depend on 32b glibc (which still uses multilib useflag instead of abi_32):
# /usr/bin/brprintconflsr2
# /usr/lib/libbrcomplpr2.so
# /usr/local/Brother/cupswrapper/brcupsconfig3

RDEPEND="
	${DEPEND}
	app-text/a2ps
	app-text/ghostscript-gpl
	app-text/psutils
	media-gfx/sane-backends
	net-print/cups
	sys-apps/sed
	virtual/libusb
"

DEVICE_NAME="MFC7820N"
DEVICE_MODEL="MFC-7820N"
DEVICE_NODE="BRN_CBF3EC"
SANE_FILE="/etc/sane.d/dll.conf"
# In older EAPI versions, the variable S would default to ${WORKDIR}/${P}. But if ${P} did not exist, the ebuild would silently fall back to the work
# directory (${WORKDIR}). Newer EAPI versions no longer do this automatic fallback to ${WORKDIR}. If you get errors like "The source directory '...'
# doesn't exist", then you're still relying on the older silent fallback behavior.
S=${WORKDIR}

pkg_setup() {
	# check if printer is available in local LAN
	ping -c1 ${DEVICE_NODE} || die "Device ${DEVICE_NAME} not found in local network!"
}

src_unpack() {
	rpm_src_unpack
}

src_install() {
	mv "${WORKDIR}"/* "${D}"

	# extracted from cupswrapperMFC7820N-2.0.1
	insinto /usr/share/cups/model
	doins "${FILESDIR}"/${DEVICE_NAME}.ppd

	# gentoo fix (http://support.brother.com/g/s/id/linux/en/faq_prn.html?c=us_ot&lang=en&redirect=on#125)
	exeinto /usr/libexec/cups/filter/
	doexe "${FILESDIR}"/brlpdwrapper${DEVICE_NAME}
}

pkg_postinst() {
	# install printer
	lpadmin -p ${DEVICE_NAME} -E -v lpd://${DEVICE_NODE}/BINARY_P1 -P /usr/share/cups/model/${DEVICE_NAME}.ppd

	# install scanner
	brsaneconfig2 -a name=${DEVICE_NAME} model=${DEVICE_MODEL} nodename=${DEVICE_NODE}
	grep -q '^brother2$' ${SANE_FILE} || echo 'brother2' >> ${SANE_FILE}
}

pkg_prerm() {
	# delete printer
	lpadmin -x ${DEVICE_NAME}

	# delete scanner
	brsaneconfig2 -r ${DEVICE_NAME}
	sed -i '/^brother2$/d' ${SANE_FILE}
}
