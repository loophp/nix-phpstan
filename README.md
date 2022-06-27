# Nix PHPStan

This [flake][nix flake] provides the [PHPStan][phpstan homepage] application.

PHPStan is a PHP Static Analysis Tool. PHPStan focuses on finding errors in your
code without actually running it. It catches whole classes of bugs even before
you write tests for the code.

The idea behind this tool is to have a quick up-and-running way to run PHPStan
on any host with Nix and without requiring it in the project.

## Usage

While being extremely stable for years, "[flake][nix flake]" is an upcoming
feature of the [Nix package manager][nix homepage]. In order to use it, you must
explicitly enable it, please check the documentation to enable it, this is
currently an opt-in option.

In your project directory, run:

```shell
nix run github:loophp/nix-phpstan
```

A working example in a PHP project:

```shell
nix run github:loophp/nix-phpstan -- analyze src/
```

or

```shell
nix run github:loophp/nix-phpstan -- --version
```

To see all the available options, run:

```shell
nix run github:loophp/nix-phpstan -- --help
```

[nix flake]: https://nixos.wiki/wiki/Flakes
[nix homepage]: https://nixos.org/
[phpstan homepage]: https://github.com/phpstan/phpstan
