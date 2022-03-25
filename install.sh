[[ "$0" != "$BASH_SOURCE" ]] && export install_dir=$(dirname "$BASH_SOURCE") || export install_dir=$(dirname $0)

sudo chmod +x version.conf
source version.conf

cp "$install_dir/yaml/instance.yaml" "$install_dir/yaml/instance_modified.yaml"
cp "$install_dir/yaml/1.istio-base.yaml" "$install_dir/yaml/1.istio-base-modified.yaml"
cp "$install_dir/yaml/jaeger-gatekeeper-forbidden-cm.yaml" "$install_dir/yaml/jaeger-gatekeeper-forbidden-cm-modified.yaml"
cp "$install_dir/yaml/2.istio-tracing.yaml" "$install_dir/yaml/2.istio-tracing-modified.yaml"
cp "$install_dir/yaml/3.istio-core.yaml" "$install_dir/yaml/3.istio-core-modified.yaml"
cp "$install_dir/yaml/4.istio-ingressgateway.yaml" "$install_dir/yaml/4.istio-ingressgateway-modified.yaml"
cp "$install_dir/yaml/5.istio-metric.yaml" "$install_dir/yaml/5.istio-metric-modified.yaml"



sed -i 's/{CUSTOM_DOMAIN_NAME}/'${CUSTOM_DOMAIN_NAME}'/g' "$install_dir/yaml/2.istio-tracing-modified.yaml"
sed -i 's/{JAEGER_VERSION}/'${JAEGER_VERSION}'/g' "$install_dir/yaml/2.istio-tracing-modified.yaml"
sed -i 's/{GATEKEEPER_VERSION}/'${GATEKEEPER_VERSION}'/g' "$install_dir/yaml/2.istio-tracing-modified.yaml"
sed -i 's/{EFK_ES_SVC_NAME}/'${EFK_ES_SVC_NAME}'/g' "$install_dir/yaml/2.istio-tracing-modified.yaml"
sed -i 's/{EFK_NAMESPACE}/'${EFK_NAMESPACE}'/g' "$install_dir/yaml/2.istio-tracing-modified.yaml"
sed -i 's/{CLIENT_ID}/'${CLIENT_ID}'/g' "$install_dir/yaml/2.istio-tracing-modified.yaml"
sed -i 's/{CLIENT_SECRET}/'${CLIENT_SECRET}'/g' "$install_dir/yaml/2.istio-tracing-modified.yaml"
sed -i 's/{CLIENT_ROLE}/'${CLIENT_ROLE}'/g' "$install_dir/yaml/2.istio-tracing-modified.yaml"
sed -i 's|{GATEKEEPER_ADDR}|'${GATEKEEPER_ADDR}'|g' "$install_dir/yaml/2.istio-tracing-modified.yaml"
sed -i 's|{REDIRECT_URL}|'${REDIRECT_URL}'|g' "$install_dir/yaml/jaeger-gatekeeper-forbidden-cm-modified.yaml"

sed -i 's/{ISTIO_VERSION}/'${ISTIO_VERSION}'/g' "$install_dir/yaml/3.istio-core-modified.yaml"
sed -i 's/{ISTIO_VERSION}/'${ISTIO_VERSION}'/g' "$install_dir/yaml/4.istio-ingressgateway-modified.yaml"


kubectl apply -f "$install_dir/yaml/1.istio-base-modified.yaml"
kubectl apply -f "$install_dir/yaml/jaeger-gatekeeper-forbidden-cm-modified.yaml"
kubectl apply -f "$install_dir/yaml/2.istio-tracing-modified.yaml"
kubectl apply -f "$install_dir/yaml/3.istio-core-modified.yaml"
kubectl apply -f "$install_dir/yaml/4.istio-ingressgateway-modified.yaml"
kubectl apply -f "$install_dir/yaml/5.istio-metric-modified.yaml"
