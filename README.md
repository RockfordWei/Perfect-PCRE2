# Perfect-PCRE2

<p align="center">
    <a href="http://perfect.org/get-involved.html" target="_blank">
        <img src="http://perfect.org/assets/github/perfect_github_2_0_0.jpg" alt="Get Involed with Perfect!" width="854" />
    </a>
</p>

<p align="center">
    <a href="https://github.com/PerfectlySoft/Perfect" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_1_Star.jpg" alt="Star Perfect On Github" />
    </a>  
    <a href="http://stackoverflow.com/questions/tagged/perfect" target="_blank">
        <img src="http://www.perfect.org/github/perfect_gh_button_2_SO.jpg" alt="Stack Overflow" />
    </a>  
    <a href="https://twitter.com/perfectlysoft" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_3_twit.jpg" alt="Follow Perfect on Twitter" />
    </a>  
    <a href="http://perfect.ly" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_4_slack.jpg" alt="Join the Perfect Slack" />
    </a>
</p>

<p align="center">
    <a href="https://developer.apple.com/swift/" target="_blank">
        <img src="https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat" alt="Swift 4.2">
    </a>
    <a href="https://developer.apple.com/swift/" target="_blank">
        <img src="https://img.shields.io/badge/Platforms-OS%20X%20%7C%20Linux%20-lightgray.svg?style=flat" alt="Platforms OS X | Linux">
    </a>
    <a href="http://perfect.org/licensing.html" target="_blank">
        <img src="https://img.shields.io/badge/License-Apache-lightgrey.svg?style=flat" alt="License Apache">
    </a>
    <a href="http://twitter.com/PerfectlySoft" target="_blank">
        <img src="https://img.shields.io/badge/Twitter-@PerfectlySoft-blue.svg?style=flat" alt="PerfectlySoft Twitter">
    </a>
    <a href="http://perfect.ly" target="_blank">
        <img src="http://perfect.ly/badge.svg" alt="Slack Status">
    </a>
</p>



This project provides an easy solution to extract captured groups from a string by a PCRE2 compatible regular expression.

This package builds with Swift Package Manager and is part of the [Perfect](https://github.com/PerfectlySoft/Perfect) project but can also be used as an independent module.

## Quick Start

### Prerequisites

#### Swift Version

Swift 4.2+

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
.package(url: "https://github.com/RockfordWei/Perfect-PCRE2.git", 
	from: "3.1.0")

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
