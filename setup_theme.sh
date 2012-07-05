#!/bin/bash
# Copyright (c) 2012, Bela <bela@dandre.hu>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#    * Neither the name of the <organization> nor the
#      names of its contributors may be used to endorse or promote products
#      derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ''AS IS''
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL <copyright holder> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


installable_theme_dir=`dirname $0`

ispconfig_interface_dir="/usr/local/ispconfig/interface/web"

themes_dir="themes"

base_template_postfix=".base"

modules_list="admin billing client dashboard dashboard/dashlets dns domain help login mail monitor sites tools vm"

echo "ISPConfig3 theme installer. Installable theme: ispc-larry"
echo ""
echo "Settings:"
echo "installable_theme_dir: $installable_theme_dir"
echo "avaliable modules: $modules_list"
echo "ispconfig_interface_dir: $ispconfig_interface_dir"
echo ""

######
function setup_module_templates()
{
	local module=$1
	
	echo "**  update theme in module $module"
	echo "target template dir $ispconfig_interface_dir/$module/templates"

	test ! -d "$ispconfig_interface_dir/$module/templates" && { echo "not found templates dir in module $module"; return 1; }

	test ! -d "$ispconfig_interface_dir/$module/templates$base_template_postfix" && { echo "backup base templates in module $module"; mv "$ispconfig_interface_dir/$module/templates" "$ispconfig_interface_dir/$module/templates$base_template_postfix"; };

	test -d "$ispconfig_interface_dir/$module/templates" && { rm -rf "$ispconfig_interface_dir/$module/templates"; }
	
	cp -r  "$installable_theme_dir/$module/templates" "$ispconfig_interface_dir/$module/templates"
	chown -R ispconfig:ispconfig "$ispconfig_interface_dir/$module/templates"
}

for m in $modules_list
do
	test ! -d "$ispconfig_interface_dir/$m" && { echo "skip. $m module not exists"; continue; }
	echo "deploying templates to module $m"
	setup_module_templates $m
done


test ! -e "$ispconfig_interface_dir/dashboard/dashboard.base.php" && mv "$ispconfig_interface_dir/dashboard/dashboard.php" "$ispconfig_interface_dir/dashboard/dashboard.base.php"

cp "$installable_theme_dir/dashboard/dashboard.php" "$ispconfig_interface_dir/dashboard/dashboard.base.php" 
chown ispconfig:ispconfig "$ispconfig_interface_dir/dashboard/dashboard.base.php"

test -e  "$ispconfig_interface_dir/themes/ispc-larry" && rm -rf "$ispconfig_interface_dir/themes/ispc-larry"
cp -r "$installable_theme_dir/themes/ispc-larry" "$ispconfig_interface_dir/themes/ispc-larry"
chown -R ispconfig:ispconfig "$ispconfig_interface_dir/themes/ispc-larry"

echo "ispc-larry theme install done."

