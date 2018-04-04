# Juli CLI

A CLI tool for generating native versions web apps for macOS, using [Juli](https://juli.getwebcatalog.com).

## Install

Install Juli CLI by cloning this repo and then running `install.sh`

```sh
$ git clone https://github.com/seaneking/juli-cli.git ~/.juli-cli
$ ~./juli-cli/install.sh
```

## Usage

Juli CLI will generate an app bundle under `~/Applications/Juli Apps/` based on the options you give it. It expects Juli to be installed in `/Applications`.

```
juli [opts]

Options:

-n --name   App name (required)
-u --url    App URL (required)
-i --icon   Path to .icns file to use
```

### TODO

- Print usage instructions if no args given
- Make application directory configurable
- Make Juli location configurable
- Provide a default icon