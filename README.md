# Perfect-PCRE2



This project provides an easy solution to extract captured groups from a string by a PCRE2 compatible regular expression.

This repo is a fork from the original and probably ought not be trusted at the moment.

This package builds with Swift Package Manager and is part of the [Perfect](https://github.com/PerfectlySoft/Perfect) project but can also be used as an independent module.

## Quick Start

### Prerequisites

#### Swift Version

Swift 5.3+

#### macOS

``` 
$ brew install pcre2
```

#### Ubuntu Linux

```
$ sudo apt-get install libpcre2-dev
```

### Swift Package Manager

Add dependencies to your Package.swift

``` swift
.package(url: "https://github.com/MrTheSaw/Perfect-PCRE2.git", 
	from: "3.1.1")

// on target section:
.target(
            // name: "your project name",
            dependencies: ["PerfectPCRE2"]),
```

### Import Perfect PCRE2 Library

Add the following header to your swift source code:

``` swift
import PerfectPCRE2
```
For swift tools 5.3, it also seems that you need to add the libpcre2-8 library to Frameworks and Libraries, probably from something like "/usr/local/Cellar/pcre2/10.36/lib", and make sure it's set to Embed and Sign. 

### Simple Usage

``` swift
let lines = try """
	HTTP/1.1 100 continue
	HTTP/1.0 200 OK
""".pcre2Match(pattern: "([A-Z]+)/([0-9.]+)\\s+([0-9]+)\\s+(.*)")

lines.forEach { line in
	print("full: $0", line[0]) // the full match
	print("head: $1", line[1]) // "HTTP"
	print("vers: $2", line[2]) // 1.1 or 1.0
	print("code: $3", line[3]) // 100 or 200
	print("stat: $4", line[4]) // continue or OK
}
```

## Further Information
For more information on the Perfect project, please visit [perfect.org](http://perfect.org).
