
# Istio 설치 가이드

## 구성 요소 및 버전
* istiod ([docker.io/istio/pilot:1.5.1](https://hub.docker.com/layers/istio/pilot/1.5.1/images/sha256-818aecc1c73c53af9091ac1d4f500d9d7cec6d135d372d03cffab1addaff4ec0?context=explore))
* istio-ingressgateway ([docker.io/istio/proxyv2:1.5.1](https://hub.docker.com/layers/istio/proxyv2/1.5.1/images/sha256-3ad9ee2b43b299e5e6d97aaea5ed47dbf3da9293733607d9b52f358313e852ae?context=explore))
* jaeger-agent[(docker.io/jaegertracing/jager-agent:1.9)](https://hub.docker.com/layers/jaegertracing/jaeger-agent/1.9/images/sha256-f214f1a411a2bbfab2fadd305f28fa2866aaf36d1ac3260901ebf5b58dae3c0e?context=explore)
* jaeger-query[(docker.io/jaegertracing/jager-queryt:1.9)](https://hub.docker.com/layers/jaegertracing/jaeger-query/1.9/images/sha256-0ca742b990db6e716171cb966225414fb382e96af4ddd0e8b5cca18e832ca36c?context=explore)
* jaeger-collector[(docker.io/jaegertracing/jager-collector:1.9)](https://hub.docker.com/layers/jaegertracing/jaeger-collector/1.9/images/sha256-17339bf58eced9c025b433219dbe0875d42b67c9b36d6a6b0e8b0fbb03adfdfe?context=explore)

* bookinfo example
    * productpage([docker.io/istio/examples-bookinfo-productpage-v1:1.15.0](https://hub.docker.com/layers/istio/examples-bookinfo-productpage-v1/1.15.0/images/sha256-0a5eb4795952372251d51f72834bccb7ea01a67cb72fd9b58b757cca103b7524?context=explore))
    * details([docker.io/istio/examples-bookinfo-details-v1:1.15.0](https://hub.docker.com/layers/istio/examples-bookinfo-details-v1/1.15.0/images/sha256-fce0bcbff0bed09116dacffca15695cd345e0c3788c15b0114a05f654ddecc17?context=explore))
    * ratings([docker.io/istio/examples-bookinfo-ratings-v1:1.15.0](https://hub.docker.com/layers/istio/examples-bookinfo-ratings-v1/1.15.0/images/sha256-09b9d6958a13ad1a97377b7d5c2aa9e0372c008cdf5a44ce3e72fbd9660936cf?context=explore))
    * reviews-v1([docker.io/istio/examples-bookinfo-reviews-v1:1.15.0](https://hub.docker.com/layers/istio/examples-bookinfo-reviews-v1/1.15.0/images/sha256-40e8aba77c1b46f37e820a60aa6948485d39e6f55f1492fa1f17383efd95511c?context=explore))
    * reviews-v2([docker.io/istio/examples-bookinfo-reviews-v2:1.15.0](https://hub.docker.com/layers/istio/examples-bookinfo-reviews-v2/1.15.0/images/sha256-e86d247b7ac275eb681a7e9c869325762686ccf0b5cfb6bde100ff2c1f01ae2b?context=explore))
    * reviews-v3([docker.io/istio/examples-bookinfo-reviews-v3:1.15.0](https://hub.docker.com/layers/istio/examples-bookinfo-reviews-v3/1.15.0/images/sha256-e454cab754cf9234e8b41d7c5e30f53a4c125d7d9443cb3ef2b2eb1c4bd1ec14?context=explore))

## Prerequisites

- EFK (elasticsearch), HpyerAuth

## 폐쇄망 설치 가이드
설치를 진행하기 전 아래의 과정을 통해 필요한 이미지 및 yaml 파일을 준비한다.
1. **폐쇄망에서 설치하는 경우** 사용하는 image repository에 istio 설치 시 필요한 이미지를 push한다.
    - [install-registry 이미지 푸시하기 참조](https://github.com/tmax-cloud/install-registry/blob/5.0/podman.md)  
2. install yaml을 다운로드한다.
    ```bash
    $ wget https://raw.githubusercontent.com/tmax-cloud/install-istio/5.0/yaml/1.istio-base.yaml
    $ wget https://raw.githubusercontent.com/tmax-cloud/install-istio/5.0/yaml/2.istio-tracing.yaml
    $ wget https://raw.githubusercontent.com/tmax-cloud/install-istio/5.0/yaml/3.istio-core.yaml
    $ wget https://raw.githubusercontent.com/tmax-cloud/install-istio/5.0/yaml/4.istio-ingressgateway.yaml
    $ wget https://raw.githubusercontent.com/tmax-cloud/install-istio/5.0/yaml/5.istio-metric.yaml
    $ wget https://raw.githubusercontent.com/tmax-cloud/install-istio/5.0/yaml/bookinfo.yaml
    ```

## Install Steps


## Step0. 폐쇄망 설정
  * `폐쇄망에서 설치를 진행하여 별도의 image registry를 사용하는 경우 registry 정보를 추가로 설정해준다.`

	```bash
  $ sed -i 's/docker.io\/jaegertracing\/jaeger-agent/'${REGISTRY}'\/jaegertracing\/jager-agent/g' 2.istio-tracing.yaml

	$ sed -i 's/docker.io\/jaegertracing\/jager-query/'${REGISTRY}'\/jaegertracing\/jaeger-query/g' 2.istio-tracing.yaml
	$ sed -i 's/docker.io\/jaegertracing\/jaeger-collector/'${REGISTRY}'\/jaegertracing\/jaeger-collector/g' 2.istio-tracing.yaml
	$ sed -i 's/docker.io\/istio/'${REGISTRY}'\/istio/g' 3.istio-core.yaml
	$ sed -i 's/docker.io\/istio\/proxyv2/'${REGISTRY}'\/istio\/proxyv2/g' 4.istio-ingressgateway.yaml
	$ sed -i 's/docker.io/'${REGISTRY}'/g' bookinfo.yaml
	```

## Step 1. hyperauth API-GATEWAY 연동
[가이드 링크](https://github.com/tmax-cloud/hyperauth/blob/main/guide/keycloak-gatekeeper/keycloak-gatekeeper.pptx)

1. 클라이언트 생성
  - Client-Protocol : openid-connect
  - Access Type : confidential

![image](figure/keycloak1.png)

2. 클라이언트 role (manager) 생성

- role를 가진 사용자만 client에 등록된 서비스에 로그인할 수 있다

![image](figure/keycloak2.png)

3. 관리자계정에 manager role 등록
   - 관리자 계정(admin) - role mappings - client roles: jaeger 선택

![image](figure/keycloak3.png)

4. 클라이언트- mapper 생성
   - Access Token Audience에 포함시키기 위함

![image](figure/keycloak4.png)

---

## Step 1. 버전 수정

* 목적 : `설치 위한 정보 기입`
* 순서 : 알맞은 config 내용 작성 [(version.conf)](./version.conf)
  - CLIENT_ID,CLIENT_SECRET,CLIENT_ROLE은 hyperauth에서 생성한 값을 이용한다

---

## Step 2. installer 실행
* 목적 : `설치 위한 쉘 스크립트 실행`
* 순서 : 권한 부여 및 스크립트 실행

```bash
$ sudo chmod +x install.sh
$ ./install.sh
```

---



## Step 3. bookinfo 예제

* 목적 : `istio 설치 검증을 위한 bookinfo 예제`
* 생성 순서 : [bookinfo.yaml](yaml/bookinfo.yaml) 실행
* 비고 :
    * bookinfo 예제 배포
        * application에 접속하기 위해 [service productpage의 타입](yaml/bookinfo.yaml#L278)을 NodePort/LoadBalancer로 변경한다.
        * bookinfo 예제를 배포할 namespace에 istio-injected=enabled label을 추가한 뒤, bookinfo 예제를 배포한다.
        ```bash
        $ kubectl label namespace $YOUR_NAMESPACE istio-injection=enabled
        $ kubectl apply -f bookinfo.yaml -n $YOUR_NAMESPACE
        ```

## 인증서 갱신 가이드

1. 인증서 갱신을 위한 스크립트 파일을 다운로드 하고 권한을 설정해준다.
    ```bash
    $ wget https://raw.githubusercontent.com/istio/tools/release-1.8/bin/root-transition.sh
    $ chmod +x root-transition.sh
    ```
2. 인증서 만료일을 확인한다.
    ```bash
    $ ./root-transition.sh check-root
    ```
3. 스크립트 파일을 이용하여 인증서를 갱신한다(10년 갱신).
    ```bash
    $ ./root-transition.sh root-transition
    ```
