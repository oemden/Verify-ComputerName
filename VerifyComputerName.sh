#!/bin/bash
# 
# Version=0.1

## TODO : 
## A LaunchDaemon to be launched at boot or on schedule
## Verify myDomain is not empty.

## Edit your LAN domain below
myDomain="int.example.com"

## ========== PREREQ =============
clear

function sudo_check {
	if [ `id -u` -ne 0 ] ; then
		printf "must be run as sudo, exiting"
		echo 
		exit 1
	fi
}

sudo_check

function check_domain {
	if [[ ! -z "${myDomain}" ]] ; then
		#echo "domain is set"
		DomainExist="1"
	fi
}

## Vars
function get_names {
	check_domain
	myComputerName=`scutil --get ComputerName`
	myHostName=`scutil --get HostName`
	myLocalHostName=`scutil --get LocalHostName`
	if [[ "${DomainExist}" == "1" ]] ; then
		NewHostName="${myLocalHostName}.${myDomain}"
	fi
}

function echo_Names {
	get_names
	echo " ---------------------------------- "
	echo "Domain: ${myDomain}"
	echo "ComputerName: ${myComputerName}"
	echo "LocalHostName: ${myLocalHostName}"
	echo "HostName: ${myHostName}"
	echo
}

echo "Current ComputerName, LocalHostName and HostName are:"
echo_Names

## Be sure ComputerName does Not contains " (0-9)"
	get_names
if [[ "${myComputerName}" =~ " (" ]] ; then
	echo "ComputerName is not correct"
	myCorrectComputerName=`echo "${myComputerName}" | awk '{print $1}'`
	echo "renaming ComputerName to \"${myCorrectComputerName}\""
	scutil --set ComputerName "${myCorrectComputerName}"
	ComputerRenamed="1" ; echo
fi

## Be sure LocalHostName == ComputerName
	get_names
if [[ "${myLocalHostName}" != "${myComputerName}" ]] ; then
	echo "LocalHostName Differs from ComputerName"
	echo "fixing it"
	if [[ "${ComputerRenamed}" == "1" ]] ; then
		echo "renaming LocalHostName to \"${myCorrectComputerName}\""
		scutil --set LocalHostName "${myCorrectComputerName}"
	else
		echo "renaming LocalHostName to \"${myComputerName}\""
		scutil --set LocalHostName "${myComputerName}"
	fi
	LocalHostNameRenamed="1" ; echo
fi

## Create HostName if empty or not like ComputerName.myDomain
	get_names
if [[ ! "${myHostName}" ]] || [[ "${myHostName}" != "${NewHostName}" ]] ; then
	if [[ "${DomainExist}" == "1" ]] ; then
		echo "HostName is not set, or not correct, setting it up"
		echo "NewHostName : ${NewHostName}"
		scutil --set HostName "${NewHostName}"
		HostNameRenamed="1" ; echo
	fi
fi

## If anything has been renamed echo again
if [[ "${ComputerRenamed}" == "1" ]] ||  [[ "${LocalHostNameRenamed}" == "1" ]] ||  [[ "${HostNameRenamed}" == "1" ]]  ; then
	echo "New Current ComputerName, LocalHostName and HostName are:"
	echo_Names
fi

exit 0

