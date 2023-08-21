# Generating_samples_lxplus
1. We have a Fragment that is used to define the process for which we need to generate sample.( Here we generate using the fragments named: JPsiToee_pythia8pT40to250gun_GEN_SIM.py which is a JPsi Gun
and generate JPsi in the pT range 40 to 250 GeV and made it to decay only to e+ and e-.
2. Next we need to run some steps that will take us from the Generated sample to Simulated sample in AODSIM and miniAODSIM format.(The shell script file: condor_script.sh has all the commands)
3. Finally to get large enough sample we have to run a condor job in lxplus. For submitting the condor job submitJobstocondor.condor is given.
 
