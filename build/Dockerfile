FROM vmware/powerclicore

# Expected environment variables are VCC_USER and VCC_PASS
ARG VCC_USER
ARG VCC_PASS

# Update image
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y wget git vim tree curl jq bash-completion bash file

# Cleanup apt-get cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install all scripts
WORKDIR /work

RUN git clone https://github.com/martencassel/vmware-tkg.git /work

# Setup bash shell
RUN bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"
#RUN sed -i 's/OSH_THEME=".*"/OSH_THEME="powerline-multiline"/' ~/.bashrc
RUN echo "source /etc/bash_completion" >> ~/.bashrc

# Install VCC (VMware Customer Connect CLI)
RUN wget https://github.com/vmware-labs/vmware-customer-connect-cli/releases/download/v1.1.7/vcc-linux-v1.1.7 -O /tmp/vcc && install -m 755 /tmp/vcc /usr/local/bin/vcc

# Install all scripts from /work/bin to /usr/local/bin
RUN bash -c 'for i in $(ls /work/bin/*.sh); do install -m 755 $i /usr/local/bin/$(basename $i); done'

# Powershell 
RUN pwsh -Command 'Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -ParticipateInCeip $false -Confirm:$false'
