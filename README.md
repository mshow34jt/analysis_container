# analysis_container
git clone http://github.com/mshow34jt/analysis_container

cd analysis_container
docker build -t analysis:v1 .

execute with:  
docker run --rm -d --network host --name analysis -v $PWD/log:/data/log  -v $PWD/ldms:/data/ldms    -v $PWD/slurm:/data/slurm  -v /etc/localtime:/etc/localtime   analysis:v1

To proceed with Singularity:
docker save analysis:v1 >analysisv1.tar

singularity build analysis.sif docker-archive://analysisv1.tar


alternatively build without docker requires root or fakeroot setup
 singularity build --fakeroot analysis.sif Singularity.def

Move the file to the desired host, and there run…

singularity instance start --bind  /storage/nvme0n1/ncsa/eclipse/store_function_csv/spool/:/data/ldms --bind /storage/slurm/eclipse/spool-bitzer/job_detail:/data/slurm --bind /etc/localtime:/etc/localtime --bind /storage/nvme0n1/ncsa/log:/data/log analysis.sif analysis

singularity run instance://analysis /jobmon/bin/init.sh

