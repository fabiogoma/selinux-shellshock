#!/bin/bash
# shellshock-test.sh

VULNERABLE=false;
CVE20146271="$(env 'x=() { :;}; echo vulnerable' 'BASH_FUNC_x()=() { :;}; echo vulnerable' bash -c "echo test" 2>&1 )"

CVE20147169=$(cd /tmp 2>&1; rm -f /tmp/echo 2>&1; env 'x=() { (a)=>\' bash -c "echo uname" 2>&1; cat /tmp/echo 2>&1; rm -f /tmp/echo 2>&1 )

if [[ "$CVE20146271" == *vulnerable* ]]
then
    echo "This system is vulnerable to CVE-2014-6271 <https://access.redhat.com/security/cve/CVE-2014-6271>"
    VULNERABLE=true;
elif [[ "$CVE20146271" == *bash:\ error\ importing\ function\ definition\ for\ \'x\'* ]]
then
    echo "This system does not have to most up to date fix for CVE-2014-6271 <https://access.redhat.com/security/cve/CVE-2014-6271>.  Please refer to 'https://access.redhat.com/articles/1200223' for more information"
else
	echo "This system is safe from CVE-2014-6271 <https://access.redhat.com/security/cve/CVE-2014-6271>"
fi

if [[ "$CVE20147169" == *Linux* ]]
then
    echo "This system is vulnerable to CVE-2014-7169 <https://access.redhat.com/security/cve/CVE-2014-7169>"
    VULNERABLE=true;
else
	echo "This system is safe from CVE-2014-7169 <https://access.redhat.com/security/cve/CVE-2014-7169>"
fi

if [[ "$VULNERABLE" = true ]]
then
	echo "Please run 'yum update bash'.  If you are using satellite or custom repos you need to update the channel with the latest bash version first before running 'yum update bash'.  Please refer to 'https://access.redhat.com/articles/1200223' for more information"
fi
