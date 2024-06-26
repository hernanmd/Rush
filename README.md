[![license-badge](https://img.shields.io/badge/license-MIT-blue.svg)](https://img.shields.io/badge/license-MIT-blue.svg)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

# Table of Contents

- [Description](#description)
- [Installation](#installation)
  - [Baseline String](#baseline-string)
- [Implementation notes](#implementation-note)
- [Contribute](#contribute)
  - [Version management](#version-management)
- [License](#license)


# Description

Implements multiple browser in Pharo

# Installation

```smalltalk
EpMonitor disableDuring: [ 
	Metacello new	
		baseline: 'Rush';	
		repository: 'github://hernanmd/Rush/src';	
		load ].
```

## Baseline String 

If you want to add the Rush to your Metacello Baselines or Configurations, copy and paste the following expression:
```smalltalk
	" ... "
	spec
		baseline: 'Rush' 
		with: [ spec repository: 'github://hernanmd/Rush/src' ];
	" ... "
```

# Usage

## Minimal Class Browser

```smalltalk
RushBasicClassBrowser new open.
```
<img width="761" alt="Screenshot 2023-08-04 at 15 17 51" src="https://github.com/hernanmd/Rush/assets/4825959/5b87d105-5415-4d3c-ad7e-14e26da4bceb">

## Alternative Class Browser

```smalltalk
RushClassBrowser new open
```
<img width="1509" alt="Screenshot 2024-04-11 at 13 27 26" src="https://github.com/hernanmd/Rush/assets/4825959/b51ba2d6-8116-4431-bce3-0913069310b9">

## Slang Browser

```smalltalk
RushSlangBrowser new open.
```
<img width="999" alt="Screenshot 2023-08-04 at 14 48 07" src="https://github.com/hernanmd/Rush/assets/4825959/ca5bf47b-e9c8-488b-855c-6b7b6b8d2459">

## Bytecode Browser

<img width="1512" alt="Screenshot 2024-04-11 at 13 19 15" src="https://github.com/hernanmd/Rush/assets/4825959/f7b98854-338a-4326-a13c-30e6f8b1bffb">

# Contribute

**Working on your first Pull Request?** You can learn how from this *free* series [How to Contribute to an Open Source Project on GitHub](https://egghead.io/series/how-to-contribute-to-an-open-source-project-on-github)

If you have discovered a bug or have a feature suggestion, feel free to create an issue on Github.
If you have any suggestions for how this package could be improved, please get in touch or suggest an improvement using the GitHub issues page.
If you'd like to make some changes yourself, see the following:    

  - Fork this repository to your own GitHub account and then clone it to your local device
  - Do some modifications
  - Test.
  - Add <your GitHub username> to add yourself as author below.
  - Finally, submit a pull request with your changes!
  - This project follows the [all-contributors specification](https://github.com/kentcdodds/all-contributors). Contributions of any kind are welcome!

## Version management 

This project use semantic versioning to define the releases. This means that each stable release of the project will be assigned a version number of the form `vX.Y.Z`. 

- **X** defines the major version number
- **Y** defines the minor version number 
- **Z** defines the patch version number

When a release contains only bug fixes, the patch number increases. When the release contains new features that are backward compatible, the minor version increases. When the release contains breaking changes, the major version increases. 

Thus, it should be safe to depend on a fixed major version and moving minor version of this project.

# License
	
This software is licensed under the MIT License.

Copyright Hernán Morales Durand, 2024.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Authors

Hernán Morales Durand
