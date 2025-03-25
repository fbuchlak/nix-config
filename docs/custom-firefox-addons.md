# Custom Firefox Addons

## Update / regenerate custom firefox addons

```sh
mozilla-addons-to-nix overlays/custom-firefox-addons/firefox-addons.json overlays/custom-firefox-addons/default.nix
sed -i 's/"autogram-na-štátnych-weboch"/"autogram-na-statnych-weboch"/g' overlays/custom-firefox-addons/default.nix
```
