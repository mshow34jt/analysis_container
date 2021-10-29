# analysis_container
git clone http://github.com/mshow34jt/analysis_container
cd analysis_container
docker build -t analysis:v1 .
docker save analysis:v1 >analysisv1.tar

Move the file to the desired host, and there run…
docker load --input analysisv1.tar
docker run --name analysis -v /storage/nvme0n1/ncsa/eclipse/store_function_csv/spool/:/data/ldms -v
/storage/slurm/eclipse/spool-bitzer/job_detail:/data/slurm -v /etc/localtime:/etc/localtime -v  /st
rage/nvme0n1/ncsa/log:/data/log  --network=host   analysis:v1
