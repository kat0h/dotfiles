#!/usr/bin/env -S deno run -A
import Dfm from "../../working/dfm/mod.ts";
import { Shell, Repository, Symlink } from "../../working/dfm/plugin/mod.ts";
import { fromFileUrl } from "https://deno.land/std@0.149.0/path/mod.ts";
import { os } from "../../working/dfm/util/mod.ts";

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

