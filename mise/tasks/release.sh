#!/usr/bin/env bash
#MISE description="Release a new version of the CLI"
#USAGE arg "<product>"
#USAGE arg "<version>"

set -eo pipefail

echo "Releasing $usage_version"
swift build -c release --triple x86_64-apple-macosx
swift build -c release --triple arm64-apple-macosx
lipo -create -output .build/"$usage_product" .build/{arm64,x86_64}-apple-macosx/release/"$usage_product"

echo "Zipping $usage_product"
temp_dir=$(mktemp -d)
zip_path="$temp_dir/$usage_product-macos.zip"
/usr/bin/ditto -c -k --keepParent .build/"$usage_product" "$zip_path"
trap 'rm -rf "$temp_dir"' EXIT

gh release create "$usage_version" \
    --title "$usage_version" \
    --notes "Release $usage_version" \
    "$zip_path"
echo "Release $usage_version created and uploaded successfully"
