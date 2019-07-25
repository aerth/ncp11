// Copyright 2018 Namecoin Developers LGPLv3+

package main

import "os"

var (
	// Used for Tor Browser.  TODO: Check whether this works on macOS.
	filenameCKBIReplaceSelf   = os.Getenv("HOME") + "/libnssckbi.dylib"
	filenameCKBIReplaceTarget = os.Getenv("HOME") + "/libnssckbi-namecoin-target.dylib"
)

const (
	// Used for system-wide applications.  TODO: Check whether this works
	// on macOS.
	filenameCKBIAlongsideTarget = "/usr/local/namecoin/libnssckbi-namecoin-target.dylib"
)
