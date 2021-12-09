sudo chmod +x version.conf
source version.conf

cd yaml

sed -i 's/{ISTIO_VERSION}/'${ISTIO_VERSION}'/g' 3.istio-core.yaml
sed -i 's/{JAEGER_VERSION}/'${JAEGER_VERSION}'/g' 2.istio-tracing.yaml
sed -i 's/{KEYCLOAK_VERSION}/'${KEYCLOAK_VERSION}'/g' 2.istio-tracing.yaml
sed -i 's/{EFK_ES_SVC_NAME}/'${EFK_ES_SVC_NAME}'/g' 2.istio-tracing.yaml
sed -i 's/{EFK_NAMESPACE}/'${EFK_NAMESPACE}'/g' 2.istio-tracing.yaml
sed -i 's/{CLIENT_ID}/'${CLIENT_ID}'/g' 2.istio-tracing.yaml
sed -i 's/{CLIENT_SECRET}/'${CLIENT_SECRET}'/g' 2.istio-tracing.yaml
sed -i 's/{CLIENT_ROLE}/'${CLIENT_ROLE}'/g' 2.istio-tracing.yaml
sed -i 's|{KEYCLOAK_ADDR}|'${KEYCLOAK_ADDR}'|g' 2.istio-tracing.yaml
sed -i 's|{REDIRECT_URL}|'${REDIRECT_URL}'|g' 2.istio-tracing.yaml
sed -i 's/{CUSTOM_DOMAIN_NAME}/'${CUSTOM_DOMAIN_NAME}'/g' 4.istio-ingressgateway.yaml
sed -i 's/{CUSTOM_DOMAIN_NAME}/'${CUSTOM_DOMAIN_NAME}'/g' 2.istio-tracing.yaml
kubectl create -f 1.istio-base.yaml
kubectl create -f 2.istio-tracing.yaml
kubectl create -f 3.istio-core.yaml
kubectl create -f 4.istio-ingressgateway.yaml
kubectl create -f 5.istio-metric.yaml
