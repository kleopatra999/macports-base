# et:ts=4
# portinstall.tcl
#
# Copyright (c) 2002 Apple Computer, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of Apple Computer, Inc. nor the names of its contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

package provide portinstall 1.0
package require portutil 1.0

set com.apple.install [target_new com.apple.install install_main]
${com.apple.install} provides install
${com.apple.install} requires main fetch extract checksum patch configure build 
${com.apple.install} deplist depends_run depends_lib
${com.apple.install} set prerun install_start

# define options
options build.target.install

# Set defaults
default build.target.install install

set UI_PREFIX "---> "

proc install_start {args} {
    global UI_PREFIX portname build.target.install destdir

    ui_msg "$UI_PREFIX Installing ${portname} into ${destdir} with target ${build.target.install}"
	
	file mkdir ${destdir}
	system "mtree -U -f /etc/ports/prefix.mtree -d -e -p ${destdir} > /dev/null"
}

proc install_main {args} {
    global portname portversion categories description depends_run contents workdir worksrcdir prefix build.type build.cmd build.target.install UI_PREFIX build.target.current

    set build.target.current ${build.target.install}
    if [catch {system "[command build]"}] {
	ui_error "Installation failed."
	return -code error "Installation failed."
    }
    return 0
}
