build:
	@echo "======= Building Docker images ======="
	@echo "======================================"

	@echo "Building trainer image..."
	docker build -f Dockerfile.trainer -t blessedmadukoma/mlip-lab9-model-training-image:latest .

	@echo "Building backend image..."
	docker build -f Dockerfile.backend -t blessedmadukoma/mlip-lab9-backend-image:latest .
	
	@echo "Building load balancer image..."
	docker build -f Dockerfile.loadbalancer -t blessedmadukoma/mlip-lab9-loadbalancer-image:latest .

	@echo "======= Build Complete ======="

push:
	@echo "======= Pushing Docker images to Docker Hub ======="
	@echo "==================================================="

	@echo "Pushing trainer image..."
	docker push blessedmadukoma/mlip-lab9-model-training-image:latest

	@echo "Pushing backend image..."
	docker push blessedmadukoma/mlip-lab9-backend-image:latest
	
	@echo "Pushing load balancer image..."
	docker push blessedmadukoma/mlip-lab9-loadbalancer-image:latest

	@echo "======= Push Complete ======="

build-push: build push

k8-deploy:
	@echo "======= Deploying to Kubernetes Cluster ======="
	@echo "==============================================="

	@echo "Applying trainer deployment..."
	kubectl apply -f trainer-deployment.yaml

	@echo "Applying backend deployment..."
	kubectl apply -f backend-deployment.yaml
	
	@echo "Applying load balancer deployment..."
	kubectl apply -f load-balancer-deployment.yaml

	@echo "======= Deployment Complete ======="

deploy: build-push k8-deploy

services:
	kubectl get services

# I need to start this to get the port for testing the cURL
url:
	@echo "Usage: make url name=<service-name> e.g. make url name=flask-load-balancer-service"
	@minikube service $(name) --url

cube-curl:
	curl "http://192.168.49.2:8443/?user_id=Alice"


