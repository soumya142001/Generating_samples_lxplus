#!/bin/sh
export HOME=/tmp
export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
export COIN_FULL_INDIRECT_RENDERING=1
echo $VO_CMS_SW_DIR
source $VO_CMS_SW_DIR/cmsset_default.sh
cd /afs/cern.ch/user/s/sosarkar/MYDEMOANALYZER/CMSSW_12_0_0/src
#eval `scram runtime -sh`
cmsenv

# Script to create Condor job for Generating AOD,MINIAOD sample in CMSSW and storing it in EOS

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
    echo "Missing Arguments"
    echo ""
    echo "./submit_condor.sh <Fragment name without .py> <FRAGEMENT OUTPUT File> <SEED> <runnumber> <OUTPUT_STEP2> <OUTPUT_STEP3> <Number of events>"
    echo ""
    echo "example: ./condor_script.sh JPsiToee_pythia8pTgun_GEN_SIM test.root 1 0 JPsi_test0 JPsi_test1 2"
    echo ""
    echo "..exiting"
    echo ""
    exit 1
fi

#Declaring Variables needed for the commands
FRAGMENT=$1
FRAGMENT_OUTPUT=$2
SEED=$3
RUNNUMBER=$4
OUTPUT_STEP2=$5
OUTPUT_STEP3=$6
nevent=$7

scram b

#Doing cmsenv and cmsRun command on the Fragment
cmsRun /afs/cern.ch/user/s/sosarkar/MYDEMOANALYZER/CMSSW_12_0_0/src/JPsiToee_pT250to500/$FRAGMENT.py $FRAGMENT_OUTPUT $SEED $RUNNUMBER $nevent

#Searching for Output file of cmsRun as it is used as input to step 2
#INPUT_STEP2=$(find . -iname $FRAGMENT*.root)
#EXTENSION1='_GEN_SIM'
INPUT_STEP2=$FRAGMENT_OUTPUT
echo "Step1 success" 

#Running cmsDriver.py
cmsDriver.py $OUTPUT_STEP2 --filein file:$INPUT_STEP2 -s DIGI:pdigi_valid,L1,DIGI2RAW,HLT:@relval2018 --conditions auto:phase1_2018_realistic --datatier GEN-SIM-DIGI-RAW -n $nevent --eventcontent FEVTDEBUGHLT --geometry DB:Extended --era Run2_2018

#Searching for output of step2 and it is input to step3
#INPUT_STEP3=$(find . -iname $OUTPUT_STEP2*.root)
EXTENSION2='_DIGI_L1_DIGI2RAW_HLT'
INPUT_STEP3=$OUTPUT_STEP2$EXTENSION2.root
echo "Step2 is success"

#Last step to produce AOD
cmsDriver.py $OUTPUT_STEP3 --filein file:$INPUT_STEP3  -s RAW2DIGI,L1Reco,RECO,RECOSIM,EI,PAT,VALIDATION:@standardValidationNoHLT+@miniAODValidation,DQM:@standardDQMFakeHLT+@miniAODDQM --conditions auto:phase1_2018_realistic --datatier GEN-SIM-RECO,MINIAODSIM,DQMIO -n $nevent --eventcontent RECOSIM,MINIAODSIM,DQM --geometry DB:Extended --era Run2_2018
echo "End step success"

mkdir -p /eos/user/s/sosarkar/condor_Jobs
mkdir -p /eos/user/s/sosarkar/condor_Jobs/AOD_output_v10
for i in $OUTPUT_STEP3*.root; do mv $i /eos/user/s/sosarkar/condor_Jobs/AOD_output_v10; done
for j in $OUTPUT_STEP3*.py; do mv $j /eos/user/s/sosarkar/condor_Jobs/AOD_output_v10; done

rm -rf $FRAGMENT*.root
rm -rf $INPUT_STEP2*.root
rm -rf $OUTPUT_STEP2*.root
rm -rf $INPUT_STEP3*.root
rm -rf $FRAGMENT_OUTPUT

rm -rf $FRAGMENT*.py
rm -rf $INPUT_STEP2*.py
rm -rf $OUTPUT_STEP2*.py
rm -rf $INPUT_STEP3*.py

echo "All success"
