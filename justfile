sudo := if `id -u` == "0" { "" } else { "sudo" }
host := `hostname`
flake := `pwd -P`
profile := "default"

default:
	@just --list

update:
	@nix flake update

check:
	@nix flake check --impure --show-trace --keep-going

rebuild: rebuild-pre
	{{sudo}} nixos-rebuild switch --impure --show-trace --flake {{flake}}#{{host}}

rebuild-pre: ff-extensions
	@git add -N .

ff-extensions:
	@mozilla-addons-to-nix overlays/custom-firefox-addons/firefox-addons.json overlays/custom-firefox-addons/default.nix
	@sed -i 's/"autogram-na-štátnych-weboch"/"autogram-na-statnych-weboch"/g' overlays/custom-firefox-addons/default.nix

why user=`whoami`:
	journalctl -xeu home-manager-{{user}}.service

persistence:
	@fzf < <( \
		{{sudo}} fd \
			--one-file-system \
			--base-directory / \
			--absolute-path \
			--type f \
			--hidden \
			--exclude '{etc/NIXOS}' \
			--exclude '{etc/.clean}' \
			--exclude '{etc/.updated}' \
			--exclude '{etc/group}' \
			--exclude '{etc/passwd}' \
			--exclude '{etc/resolv.conf}' \
			--exclude '{etc/shadow}' \
			--exclude '{etc/subgid}' \
			--exclude '{etc/subuid}' \
			--exclude '{etc/sudoers}' \
			--exclude '{tmp}' \
		)
