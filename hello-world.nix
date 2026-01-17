# nix eval --file ./hello-world.nix
let
    addNumbers = {x, y ? 1 }: x + y;
in addNumbers {x = 100;}