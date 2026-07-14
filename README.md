# dotfiles

Portable zsh enhancements — symlinked into any machine, while your
machine-specific config stays in your own `~/.zshrc`.

## What's in here

```
dotfiles/
├── bootstrap.sh            # installs dependencies + symlinks enhancements
└── zsh/
    ├── enhancements.zsh    # portable enhancements (symlinked to ~/.zsh-enhancements)
    ├── p10k.zsh            # Powerlevel10k prompt config (symlinked to ~/.p10k.zsh)
```

### enhancements.zsh (portable — what gets symlinked)

Interactive shell features that work identically across machines:
- **Zinit** plugin manager (self-bootstraps)
- **Powerlevel10k** prompt theme + instant prompt
- **zsh-syntax-highlighting** — colors valid/invalid commands as you type
- **zsh-completions** — extra completion definitions
- **zsh-autosuggestions** — ghost-text suggestions from history
- **fzf-tab** — fuzzy tab-completion menu with previews (eza/bat)
- **fzf** shell integration (Ctrl+R fuzzy history, etc.)
- **zoxide** smart cd (frecency-based, aliased to `cd`)
- History settings (shared, deduped, 5000 entries)
- Keybindings (emacs mode, arrow-key history search)
- Aliases (`ls --color`)

## Setting up a new machine

```bash
git clone <your-remote-url> ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

This will:
1. Install Homebrew if missing (macOS)
2. Install `fzf`, `zoxide`, `eza`, `bat`, `git` via Homebrew if missing
3. Symlink `enhancements.zsh` → `~/.zsh-enhancements`
4. Symlink `p10k.zsh` → `~/.p10k.zsh`

Then manually:
1. Add `source ~/.zsh-enhancements` to the **top** of your `~/.zshrc`
2. Open a new terminal — zinit auto-installs all plugins on first launch

## Customizing your local copy

**Reconfigure the prompt terminal UI:**

```bash
p10k configure
```

This rewrites `~/.p10k.zsh` (which is symlinked to `zsh/p10k.zsh` in the repo).

**Edit enhancements:**

Open `~/.zsh-enhancements` in any editor — it's a symlink to
`~/dotfiles/zsh/enhancements.zsh`. Add plugins, change keybindings,
tweak history settings, etc. Then `source ~/.zshrc` to apply.

## Undoing / Uninstalling

Remove `source ~/.zsh-enhancements` from `~/.zshrc`.

## Keeping enhancements in sync (requires fork)

Since `~/.zsh-enhancements` is a symlink to `~/dotfiles/zsh/enhancements.zsh`,
any edits to your enhancements land directly in this repo. Just commit and push:

```bash
cd ~/dotfiles && git add -A && git commit -m "update enhancements" && git push
```

On another machine, `git pull` picks up the changes immediately.
