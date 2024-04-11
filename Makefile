default:
	docker build -f ./build/Dockerfile --no-cache -t vmware-tkg:latest .
	docker image tag  vmware-tkg:latest  ghcr.io/martencassel/vmware-tkg:latest

run:
	@docker run -it --rm -v $(PWD):/work -e VCC_USER=${VCC_USER} -e VCC_PASS=${VCC_PASS} ghcr.io/martencassel/vmware-tkg:latest

publish:
	@echo ${GITHUB_PAT}|docker login --username martencassel --password-stdin ghcr.io
	docker image tag vmware-tkg:latest  ghcr.io/martencassel/vmware-tkg:latest
	docker image push ghcr.io/martencassel/vmware-tkg:latest
