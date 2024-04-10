default:
	docker build -t vmware-tkg:latest .

run:
	@docker run -it --rm -v $(PWD):/work -e VCC_USER=${VCC_USER} -e VCC_PASS=${VCC_PASS} vmware-tkg:latest