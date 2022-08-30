#!/usr/bin/env -S deno run -A
import Dfm from "../../dev/dfm/mod.ts";
import { Shell, Repository, Symlink } from "../../dev/dfm/plugin/mod.ts";
import { fromFileUrl } from "https://deno.land/std@0.149.0/path/mod.ts";
import { os } from "../../dev/dfm/util/mod.ts";

const dfm = new Dfm({
  dotfilesDir: "~/dotfiles",
  dfmFilePath: fromFileUrl(import.meta.url),
});

const links: [string, string][] = [
  ["zshrc", "~/.zshrc"],
  ["tmux.conf", "~/.tmux.conf"],

  ["vimrc", "~/.vimrc"],
  ["vim", "~/.vim"],

  ["config/alacritty", "~/.config/alacritty"],
  ["config/nvim", "~/.config/nvim"]
];

const cmds: string[] = [
  "vim",
  "nvim",
  "clang",
  "curl",
  "wget",
];

let path: string[] = [
  "~/.deno/bin",
  '~/.cargo/env',
]

if (os() == "darwin") {
  path = path.concat([

    "~/mybin",
    "/usr/local/opt/ruby/bin"

  ])

} else if (os() == "linux") {
  path = path.concat([
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
