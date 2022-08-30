# analysis_container
git clone http://github.com/mshow34jt/analysis_container

cd analysis_container

### to build with Docker
docker build -t analysis:v1 .  

execute with:    
docker run --rm -d --network host --name analysis -v $PWD/log:/data/log  -v $PWD/ldms:/data/ldms    -v $PWD/slurm:/data/slurm  -v /etc/localtime:/etc/localtime   analysis:v1 

### To proceed with Singularity as an alternative:  
docker save analysis:v1 >analysisv1.tar  

singularity build analysis.sif docker-archive://analysisv1.tar  

alternatively build without docker requires root or fakeroot setup
steps to build image (sif file) and start instance (example):
* In the wscont/ folder, as the container owner user, run ./dock2sing.sh (generates Singularity.def)
* Be sure to setup "fakeroot" requirements first if not there already.
*    https://sylabs.io/guides/3.5/user-guide/cli/singularity_config_fakeroot.html
singularity build --fakeroot analysis.sif Singularity.def  

### Move the file to the desired host, and there run…  

singularity instance start --bind  /storage/nvme0n1/ncsa/eclipse/store_function_csv/spool/:/data/ldms --bind /storage/slurm/eclipse/spool-bitzer/job_detail:/data/slurm --bind /etc/localtime:/etc/localtime --bind /storage/nvme0n1/ncsa/log:/data/log analysis.sif analysis  

singularity run instance://analysis /jobmon/bin/init.sh  

