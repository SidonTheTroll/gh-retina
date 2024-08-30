<h1 align='center'>gh-retina</h1>

<div align="center">
    <img src="https://img.shields.io/static/v1?label=GhCLI&logo=github&message=2.0.0+&color=FF6B6B&logoColor=white&style=for-the-badge"/>
    <img src="https://img.shields.io/static/v1?label=Language&message=Shell&color=90E59A&logo=gnubash&logoColor=white&style=for-the-badge"/>
    <img src="https://img.shields.io/static/v1?label=License&message=GPLv3&color=blue&logo=linux&logoColor=white&style=for-the-badge"/>
</div>


An extension for [Github Cli](https://github.com/cli/cli) to show user's info. Inspired by [dylanaraps/neofetch](https://github.com/dylanaraps/neofetch) and replacement for [sheepla/gh-userfetch](https://github.com/sheepla/gh-userfetch)

## Usage 

Run `gh retina <username>` but make sure that you are logged in.

Can also run just by `gh retina` but **doesn't show the profile photo**. 

## Installation

Requires [GitHub CLI](https://github.com/cli/cli) v2.0.0+ and [stedolan/jq](https://github.com/stedolan/jq).

```sh
git clone https://github.com/SidonTheTroll/gh-retina/ ~/.local/share/gh/extensions/ 
```

Or directly install extension

```sh
gh extension install SidonTheTroll/gh-retina
```

## Media 

| <img align=center src=./img/1.png> | <img align=center src=./img/2.png> | 
|-|-|

## Dependencies

1. [Kitty](https://github.com/kovidgoyal/kitty)
2. [ImageMagick](https://www.imagemagick.org/)
3. [Curl](https://www.geeksforgeeks.org/curl-command-in-linux-with-examples/)

## Contributing

Contact me on [Discord](https://discord.com/users/728604179186188368) or fork the project and start a PullRequest.
