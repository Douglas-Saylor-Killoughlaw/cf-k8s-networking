module code.cloudfoundry.org/cf-k8s-networking/routecontroller

go 1.13

require (
	github.com/go-logr/logr v0.1.0
	github.com/gogo/protobuf v1.3.0
	github.com/montanaflynn/stats v0.6.3
	github.com/onsi/ginkgo v1.14.2
	github.com/onsi/gomega v1.10.3
	github.com/prometheus/client_model v0.1.0
	github.com/prometheus/prom2json v1.3.0
	github.com/sirupsen/logrus v1.4.2
	google.golang.org/appengine v1.6.5 // indirect
	istio.io/api v0.0.0-20200410141105-715a3039a0b5
	k8s.io/api v0.17.4
	k8s.io/apiextensions-apiserver v0.0.0-20191014073835-8a3b46923ae0 // indirect
	k8s.io/apimachinery v0.17.4
	k8s.io/client-go v0.17.4
	sigs.k8s.io/controller-runtime v0.4.0
	sigs.k8s.io/kind v0.7.0
)
