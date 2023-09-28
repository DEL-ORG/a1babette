ARG TAG
FROM ubuntu:$TAG 
WORKDIR /BUILDER
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -y && apt install -y  ansible \
   curl  wget\
   git \
   gnupg \
   jq \
   openssh-client \
   postgresql-client \
   python3 \
   nodejs \
   npm  \                       
   vim \
   wget \
   pip \
   net-tools \
   iputils-ping \
   awscli \
   default-jre \
   default-jdk \
   maven \
   ufw \
   golang   

RUN apt-get update && \
    apt-get install -y linux-headers-generic


RUN  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN  curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
RUN  echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
RUN  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl &&  \
      chmod +x kubectl  &&  \
      mkdir -p ~/.local/bin && \
      mv ./kubectl ~/.local/bin/kubectl
 
RUN apt-get update  && \
      git clone https://github.com/ahmetb/kubectx /usr/local/kubectx && \
      ln -s /usr/local/kubectx/kubectx /usr/local/bin/kubectx  && \
      ln -s /usr/local/kubectx/kubens /usr/local/bin/kubens


RUN apt-get update &&  apt-get install -y gnupg software-properties-common 
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN gpg --no-default-keyring  --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg  --fingerprint


RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
          https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
         tee /etc/apt/sources.list.d/hashicorp.list
RUN apt update &&  apt install  -y terraform



RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \  
    chmod 700 get_helm.sh && \
    ./get_helm.sh

ARG APP_NAME   
ARG ENV       
ENV TEAM=Devops 
USER 0  
RUN mkdir -p /root/REPOS/GIT FRONTEND    &&  useradd -m builder 
RUN git clone https://github.com/devopseasylearning/KFC-app.git && \
    git clone  https://github.com/devopseasylearning/awesome-compose.git  && \ 
    git clone  https://github.com/devopseasylearning/production-deployment.git
EXPOSE 80-3029 3031-4877  4597-6000
COPY  K8S backend .
COPY frontend  FRONTEND/
USER builder 
