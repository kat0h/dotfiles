#!/usr/bin/env -S deno run -A
import Dfm from "https://deno.land/x/dfm@v0.11/mod.ts";
import { Shell, Repository, Symlink } from "https://deno.land/x/dfm@v0.11/plugin/mod.ts";
import { os } from "https://deno.land/x/dfm@v0.11/util/mod.ts";
import { fromFileUrl } from "https://deno.land/std@0.149.0/path/mod.ts";

const dfm = new Dfm({
  dotfilesDir: "~/dotfiles",
  dfmFilePath: fromFileUrl(import.meta.url),
});

let links: [string, string][] = [
  ["zshrc", "~/.zshrc"],
  ["tmux.conf", "~/.tmux.conf"],

  ["vimrc", "~/.vimrc"],
  ["vim", "~/.vim"],

  ["config/alacritty", "~/.config/alacritty"],
  ["config/nvim", "~/.config/nvim"]
];

if (os() == "linux") {
  links = links.concat([
    ["config/libskk", "~/.config/libskk"],
    ["config/sway", "~/.config/sway"],
    // ["config/electron-flags.conf", "~/.config/electron-flags.conf"]
    // ["bin/swayon", "/usr/local/bin/swayon"]
    ["config/waybar", "~/.config/waybar"],
  ])
}

const cmds: string[] = [
  "vim",
  "nvim",
  "clang",
  "curl",
  "wget",
];

let path: string[] = [
  "~/.deno/bin",
  "~/.cargo/env",
]

if (os() == "darwin") {
  path = path.concat([

    "~/mybin",
    "/usr/local/opt/ruby/bin",
    // Mac標準のコマンドを書き換える
    "/usr/local/opt/bison/bin"

  ])

} else if (os() == "linux") {
  path = path.concat([
    "~/dotfiles/bin"
  ])
}


dfm.use(
  new Symlink(dfm, links),
  new Shell({
    env_path: "~/.cache/env",
    cmds: cmds,
    path: path
  }),
  new Repository(dfm),
);
dfm.end();
// vim:filetype=typescript
