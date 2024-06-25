# Generating_samples_lxplus
1. The fragment is the file where the process is defined and acts as the first step in this process. Here the fragment used is: JPsiToee_pythia8pT40to250gun_GEN_SIM.py which is a JPsi Gun
and generate JPsi in the pT range 40 to 250 GeV and made it decay only to e+ and e-.
2. Next a few commands have to be run, that will take the Generated sample to the Simulated sample in AODSIM and miniAODSIM format. (The shell script file: condor_script.sh has all the commands in a sequential manner)
3. Finally to get a large enough sample i.e a sample with many events a condor job can be run on lxplus. For submitting the condor job submitJobstocondor.condor is also included.
 
