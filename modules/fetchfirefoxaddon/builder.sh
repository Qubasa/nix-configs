source $stdenv/setup

header "exporting $url (rev $rev) into $out"

UUID="${extid}"
header "UUID is $UUID"
mkdir -p "$out/$UUID"
unzip -q ${src} -d "$out/$UUID"
NEW_MANIFEST=$(jq '. + {"applications": { "gecko": { "id": "${extid}" }}, "browser_specific_settings":{"gecko":{"id": "${extid}"}}}' "$out/$UUID/manifest.json")
echo "$NEW_MANIFEST" > "$out/$UUID/manifest.json"
cd "$out/$UUID"
zip -r -q -FS "$out/$UUID.xpi" *
rm -r "$out/$UUID"
