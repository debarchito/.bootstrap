## 0. What is this repo about?

> [!TIP]
>
> You can now _bootstrap_ your own `.bootstrap` projects! For example:
>
> ```fish
> nix run \
>   sourcehut:~debarchito/.bootstrap#generate bootstrap ~/.bootstrap \
>   host="laptop" system="x86_64-linux" stateVersion="26.05" \
>   user="demo"
> ```
>
> This is rather experimental. Please report bugs if you end up using it!

`.bootstrap` implements a bootstrapping framework (hence the name) around
[flake-parts's flakeModules](https://flake.parts/options/flake-parts-flakemodules)
using the [Dendritic](https://github.com/mightyiam/dendritic) pattern. It
implements everything as host-agnostic [feature options](/modules/features)
making them portable and reusable across any `.bootstrap` project. It also
standardizes a convention to implements [packages](/modules/packages) that can
be directly consumed via `nix build` and `nix run`. For example:

```fish
# Run CUDA-enabled Blender; upstream nixpkgs doesn't enable CUDA by default
nix run sourcehut:~debarchito/.bootstrap#blender
```

It also standardizes globally shared [overlays](/modules/overlays).

`.bootstrap` builds a subset of packages on GitHub Actions and uploads the
artifacts to my cache registry at
[debarchito.cachix.org](https://debarchito.cachix.org). You can take a look at
what's built every commit [here](/.github/workflows/build.yml). If you want to
use these packages, add my cachix as a substituter:

```nix
nix.settings = {
  substituters = [ "https://debarchito.cachix.org" ];
  trusted-public-keys = [
    "debarchito.cachix.org-1:md/bk3JZDoFjVOa6bsIDqaY5hcSec4KPWn8q3PbpCl8="
  ];
};
```

Alternatively, the
[options-trustedSubstituters](/modules/features/trusted-substituters.nix) module
can be enabled to set this up automatically. To note, this module is part of the
`nixos` class and is not importable inside a `homeManager` class.

## 1. Preparation

Apply the disk layout using [disko](https://github.com/nix-community/disko):

> [!WARNING]\
> This will erase all existing data on disk!

```fish
run0 nix --extra-experimental-features 'nix-command flakes' \
  run github:nix-community/disko/latest -- --mode destroy,format,mount \
  ./modules/hosts/<host>/_raw/disko-configuration.nix
```

> NOTE: Disko isn't automatically integrated at the moment of writing. Although,
> it can already be used to apply the layout. This will be addressed in future
> revisions.

## 2. Applying the configurations

Clone this repository to `~/.bootstrap`. This is the assumption throughout the
steps.

```
git clone https://git.sr.ht/~debarchito/.bootstrap ~/.bootstrap
# or
git clone git@git.sr.ht:~debarchito/.bootstrap ~/.bootstrap
```

Fresh installs generate their fresh `/etc/nixos/hardware-configuration.nix`.
This is the configuration your system should build against. Override the old
hardware configuration using:

```fish
cp /etc/nixos/hardware-configuration.nix ~/.bootstrap/modules/hosts/<host>/_raw/hardware-configuration.nix
# DO NOT REPLACE ~/.bootstrap/modules/hosts/<host>/hardware-configuration.nix by mistake! Notice the "_raw".
```

When applying the NixOS configuration for the _first time_, pass these options:

```fish
cd ~/.bootstrap
run0 nixos-rebuild switch --flake .#<host> \
  --option experimental-features \
    'nix-command flakes' \
  --option extra-substituters \
    'https://install.determinate.systems https://attic.xuyh0120.win/lantian' \
  --option extra-trusted-public-keys \
    'cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM= lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc='
```

This configuration depends on
[Determinate Nix](https://docs.determinate.systems/determinate-nix) and the
CachyOS kernel from
[xddxdd/nix-cachyos-kernel](https://github.com/xddxdd/nix-cachyos-kernel).
Substituters are required to avoid compiling these packages locally.

Once done, subsequent builds can be applied using:

```fish
run0 nixos-rebuild switch --flake .#<host>
```

This also enables the [nh](https://github.com/nix-community/nh) as an
alternative ([NH_FLAKE](https://github.com/nix-community/nh#nixos) is set to
`~/.bootstrap`):

```fish
nh os switch -c <host>
```

Now, apply the Home-Manager build using:

```fish
home-manager switch --flake .#<user>@<host>
# or:
nh home switch -c <user>@<host>
```

The
[Papirus Icon Theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git)
is installed during the _first_ activation; so it's fine in case it looks stuck!

## 3. Templates

This repo also contains a templating engine alongside tailored development
templates. Get started using:

```fish
nix run sourcehut:~debarchito/.bootstrap#generate
```

Initialize a template (e.g. OCaml) using:

```fish
nix run sourcehut:~debarchito/.bootstrap#generate \
    ocaml \
    ./hello-world \
    name="hello-world" \
    synopsis="The first program" \
    description="The first program that says hello to the world!"
```

Now, you can run it using:

```fish
nix run ./hello-world
```

## 4. Licensing

The repository is licensed under the [zlib](/LICENSE) license unless stated
otherwise.
