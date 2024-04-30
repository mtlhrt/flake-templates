## 🌙🦀 nightly-rust
An easily tweakable generic nightly Rust project Nix flake template, made with the intent to be
simple but not too basic and complete but not bloated.
Requires [direnv](https://github.com/direnv/direnv) for the development environment.

It includes:
- [Just](https://github.com/casey/just) as a command runner.
- [Crane](https://github.com/ipetkov/crane) for managing builds, checks and tests (`just build`, `just run`).
- [treefmt(-nix)](https://github.com/numtide/treefmt-nix) for project-wide formatting (`nix fmt`).
- [Bacon](https://github.com/Canop/bacon) for background code checking (`just watch`).
- [cargo-udeps](https://github.com/est31/cargo-udeps) for pruning unused dependencies (`just udeps`).

Linting is configured to be stricter,
and some harmless [options to minimise binary size and shorten compile times](https://github.com/johnthagen/min-sized-rust) are applied
(see `Cargo.toml` for both).

#### Setup
1. Initialise it with `nix flake init --template github:comfybyte/flake-templates#nightly-rust`.
2. Run `direnv allow` to automatically get dropped into the development environment.
3. Tweak linting rules, toolchain or system targets, etc. to your wants.
