This floder include:
1.Use azure template to setup K8S clusters through acs-engine.
deploy.sh
parameters.json #No need to update
template.json #Can define DnsNamePrefix,agentCount,agentVMSize,sshRSAPublicKey,masterCount,etc

>./deploy.sh 	#script run on any server with azure-cli;
		#Needed input is subscription ID like:
			7c91db0e-eb7f-491b-997f-32cf55b85dea
		#resource group name;this group need to be created in advance.
		#deployment name:
                #az group deployment create -n <deployname> -g <resourcegroupname> --template-file template.json --parameters @parameters.json
		#masterFQDN is <masterDnsNamePrefix>.<location>.cloudapp.azure.com

2.Prepare docker images in Azure registry repo.
00_PRE-docker-registry-setup.sh

3.Install/config glusterfs on K8S clusters and deploy flow  & drools on K8S.
ssh/ #ssh-key
0_k8s-config.txt  #config file which includes Azure registry repo hostname, K8S  cluster info, app data volume info etc.

>./10_k8s-master-preconfig.sh  #script run on any server with azure-cli
>./20_ssh-key-upload.sh #script run on k8s master
>./50_docker-image-repo-setup-privateregistry.sh #script run on k8s master
>./60_check-service.sh  #script run on k8s master
>./61_flow-deploy.sh  #script run on k8s master
>./62_flow-connect-test.sh  #script run on k8s master

4.others:
If any gluster volume issue, try below ways to fix it.
>./41_check-glusterfs-volume.sh #script run on k8s master
>./42_reconfig-glusterfs.sh #script run on k8s master
>./40_glusterfs-master-config.sh #script run on k8s master
