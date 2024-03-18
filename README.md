## 🌙🦀 nightly-rust
*Note that this template is made for my own personal use and a work-in-progress. Do feel free to use it if you want.*

A generic nightly Rust project Nix flake template, with [Crane](https://github.com/ipetkov/crane) for building, checking and testing,
and [treefmt(-nix)](https://github.com/numtide/treefmt-nix) for project code formatting. Also includes a 
[direnv](https://github.com/direnv/direnv) devshell with [Bacon](https://github.com/Canop/bacon) for background code checking,
and [Just](https://github.com/casey/just)
as a command runner.

Linting is configured to be stricter,
and some small [options to minimise binary size](https://github.com/johnthagen/min-sized-rust) are applied
(see `Cargo.toml` for both).

After `nix flake init`'ing:
- Run `direnv allow` to use the devshell.
- Change project name in `Cargo.toml` and `flake.nix`'s `pname` let binding.
- See `Justfile` for useful commands.
