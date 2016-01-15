Name: docker-scripts
Version: 0.1.%{BUILD_NUMBER}
Release: 1
Summary: Tools and scripts for managing docker
Group: Tools/Docker
License: GPL
URL: http://poixson.com/
BuildArch: noarch
Prefix: %{_bindir}/docker-scripts
%define  _rpmfilename  %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm
Requires: docker-engine
Requires: shellscripts

%description
Tools and scripts for managing docker images and containers.



%prep



%build



%install
echo
echo "Install.."
# delete existing rpm's
%{__rm} -fv "%{_rpmdir}/%{name}"*.noarch.rpm
# create directories
%{__install} -d -m 0755 \
	"${RPM_BUILD_ROOT}%{prefix}/" \
		|| exit 1
# copy script files
for scriptfile in \
	docker-common.sh   \
	docker-start.sh    \
	docker-stop.sh     \
	docker-console.sh  \
	docker-build.sh    \
	docker-rmi-all.sh  \
	docker-list.sh     \
	docker-list-all.sh \
; do
        %{__install} -m 0555 \
                "%{SOURCE_ROOT}/src/${scriptfile}" \
                "${RPM_BUILD_ROOT}%{prefix}/${scriptfile}" \
                        || exit 1
done
# alias symlinks
ln -sf  "%{prefix}/docker-start.sh"     "${RPM_BUILD_ROOT}%{_bindir}/docker-start"
ln -sf  "%{prefix}/docker-stop.sh"      "${RPM_BUILD_ROOT}%{_bindir}/docker-stop"
ln -sf  "%{prefix}/docker-console.sh"   "${RPM_BUILD_ROOT}%{_bindir}/docker-console"
ln -sf  "%{prefix}/docker-build.sh"     "${RPM_BUILD_ROOT}%{_bindir}/docker-build"
ln -sf  "%{prefix}/docker-rmi-all.sh"   "${RPM_BUILD_ROOT}%{_bindir}/docker-rmi-all"
ln -sf  "%{prefix}/docker-list.sh"      "${RPM_BUILD_ROOT}%{_bindir}/docker-list"
ln -sf  "%{prefix}/docker-list-all.sh"  "${RPM_BUILD_ROOT}%{_bindir}/docker-list-all"
# create config file
%{__cat} <<EOF >"${RPM_BUILD_ROOT}%{_sysconfdir}/docker-scripts.conf"
#!/bin/sh

DOCKER_IMAGE_ORG='poixson'
EOF
%{__chmod} 0555 \
	"${RPM_BUILD_ROOT}%{_sysconfdir}/docker-scripts.conf" \
		|| exit 1



%check



%clean
if [ ! -z "%{_topdir}" ]; then
	%{__rm} -rf --preserve-root "%{_topdir}" \
		|| echo "Failed to delete build root (probably fine..)"
fi



### Files ###
%files
%defattr(-,root,root,-)
%{prefix}/docker-common.sh
%{prefix}/docker-start.sh
%{prefix}/docker-stop.sh
%{prefix}/docker-console.sh
%{prefix}/docker-build.sh
%{prefix}/docker-rmi-all.sh
%{prefix}/docker-list.sh
%{prefix}/docker-list-all.sh
%{_bindir}/docker-start
%{_bindir}/docker-stop
%{_bindir}/docker-console
%{_bindir}/docker-build
%{_bindir}/docker-rmi-all
%{_bindir}/docker-list
%{_bindir}/docker-list-all
%config %{_sysconfdir}/docker-scripts.conf
