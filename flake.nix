# flake.nix
{
  description = "Impure-style Python shell (pip/conda like normal Linux)";

  inputs = {
    # You can switch to nixos-unstable if you like
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;  # needed if you use anaconda/conda that’s unfree
      };
    };

    python = pkgs.python3Full;
  in {
    devShells.${system}.default = pkgs.mkShell {
      name = "impure-python-env";

      buildInputs = [
        python
        pkgs.python3Packages.virtualenv

        # Optional: one of these, depending on what your nixpkgs has
        # pkgs.conda
        pkgs.micromamba
      ];

      # Let pip install into ./_pip_env and put that on PATH/PYTHONPATH
      shellHook = ''
        export PIP_PREFIX="$PWD/.pip-env"
        export PYTHONUSERBASE="$PIP_PREFIX"
        export PATH="$PIP_PREFIX/bin:$PATH"

        # Add site-packages from the local pip env
        pyver=$(${python}/bin/python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
        export PYTHONPATH="$PIP_PREFIX/lib/python$pyver/site-packages:$PYTHONPATH"

        echo
        echo "Impure-ish Python shell:"
        echo "  - python:   $(${python}/bin/python --version 2>&1)"
        echo "  - pip env:  $PIP_PREFIX"
        echo
        echo "You can now:"
        echo "  - pip install <pkgs>      (installed into ./ .pip-env)"
        echo "  - python, ipython, etc."
        echo "  - virtualenv venv && source venv/bin/activate"
        echo "  - conda create -n ...     (if you enabled conda/anaconda)"
        echo
      '';
    };
  };
}
