#!/bin/bash
set -euo pipefail

REGISTRY="oci://ghcr.io/ahyattdev/helm-charts"

for chart_dir in charts/*/; do
    chart_yaml="${chart_dir}Chart.yaml"
    
    if [[ ! -f "$chart_yaml" ]]; then
        echo "Skipping $chart_dir: no Chart.yaml found"
        continue
    fi

    name=$(yq '.name' "$chart_yaml")
    version=$(yq '.version' "$chart_yaml")

    echo "Publishing $name@$version..."
    
    helm package "$chart_dir"
    helm push "${name}-${version}.tgz" "$REGISTRY"
    rm "${name}-${version}.tgz"
done

echo "Done!"

