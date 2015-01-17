#!/bin/tcsh
#===================================================================================================
# Submit a set of jobs to run over a given dataset, splitting the jobs according to the filesets.
#
# Version 1.0                                                                      November 14, 2008
#===================================================================================================


##########################
# Baseline Razor Analysis
##########################
foreach sample( \
SMS-T1tttt_2J_mGl-1500_mLSP-100\
SMS-T1bbbb_2J_mGl-1500_mLSP-100\
SMS-T1tttt_2J_mGl-1200_mLSP-800\
SMS-T1bbbb_2J_mGl-1000_mLSP-900\
SMS-T1qqqq_2J_mGl-1400_mLSP-100\
SMS-T1qqqq_2J_mGl-1000_mLSP-800\
TTJets \
QCDHT100To250 \
QCDHT250To500 \
QCDHT500To1000 \
QCDHT1000ToInf \
WJetsToLNu_HT100To200 \
WJetsToLNu_HT200To400 \
WJetsToLNu_HT400To600 \
WJetsToLNu_HT600ToInf \
DYJetsToLL_HT100To200 \
DYJetsToLL_HT200To400 \
DYJetsToLL_HT400To600 \
DYJetsToLL_HT600ToInf \
ZJetsToNuNu_HT100To200 \
ZJetsToNuNu_HT200To400 \
ZJetsToNuNu_HT400To600 \
ZJetsToNuNu_HT600ToInf \
T_tW \
TBar_tW \
TToLeptons_s \
TBarToLeptons_s \
TToLeptons_t \
TBarToLeptons_t \
WZJetsTo3LNu \
TTWJets \
TTZJets \
) 
  echo "Sample " $sample
  set inputfilelist="/afs/cern.ch/work/s/sixie/public/releases/run2/CMSSW_7_2_0/src/RazorAnalyzer/lists/razorNtuplerV1p4-25ns_v1_v1/${sample}_20bx25.cern.txt"
  set filesPerJob = 1
  set nfiles = `cat $inputfilelist | wc | awk '{print $1}' `
  set maxjob=`python -c "print int($nfiles.0/$filesPerJob)-1"`

  foreach jobnumber(`seq 0 1 $maxjob`)
    echo "job " $jobnumber " out of " $maxjob
    bsub -q 1nd -o /afs/cern.ch/user/s/sixie/work/private/condor/res/Run2SUSY/RazorAnalysis/Razor_${jobnumber}.out -J RazorAnalysis_Razor_${jobnumber} /afs/cern.ch/work/s/sixie/public/releases/run2/CMSSW_7_2_0/src/RazorAnalyzer/scripts/runRazorJob_CERN.csh razor $inputfilelist -1 $filesPerJob $jobnumber RazorAnalysis_${sample}_20bx25.Job${jobnumber}Of${maxjob}.root /afs/cern.ch/user/s/sixie/work/public/Run2SUSY/RazorAnalysis/jobs/
    sleep 0.1
  end

end



##########################
# Veto Lepton Study
##########################
foreach sample( \
T1bbbb_1500
T1tttt_1500
TTJets \
) 
  set inputfilelist="/afs/cern.ch/work/s/sixie/public/releases/run2/CMSSW_7_2_0/src/RazorAnalyzer/lists/razorNtuplerV1p4-25ns_v1_v1/${sample}_20bx25.cern.txt"
  set filesPerJob = 1
  set nfiles = `cat $inputfilelist | wc | awk '{print $1}' `
  set maxjob=`python -c "print int($nfiles.0/$filesPerJob)-1"`
  echo "Sample " $sample " maxjob = " $maxjob

  foreach jobnumber(`seq 0 1 $maxjob`)
    echo "job " $jobnumber " out of " $maxjob
    bsub -q 1nd -o /afs/cern.ch/user/s/sixie/work/private/condor/res/Run2SUSY/RazorAnalysis/VetoLeptonStudy_${jobnumber}.out -J RazorAnalysis_VetoLeptonStudy_${jobnumber} /afs/cern.ch/work/s/sixie/public/releases/run2/CMSSW_7_2_0/src/RazorAnalyzer/scripts/runRazorJob_CERN.csh razorVetoLeptonStudy $inputfilelist 1 $filesPerJob $jobnumber VetoLeptonStudy_${sample}_25ns.Job${jobnumber}Of${maxjob}.root /afs/cern.ch/user/s/sixie/work/public/Run2SUSY/VetoLeptonStudy/jobs/
    sleep 0.1
  end

end


##########################
# Electron Ntupler
##########################
foreach sample( \
T1bbbb_1500
T1tttt_1500
TTJets \
DYJetsToLL \
)

  set inputfilelist="/afs/cern.ch/work/s/sixie/public/releases/run2/CMSSW_7_2_0/src/RazorAnalyzer/lists/razorNtuplerV1p4-25ns_v1_v1/${sample}_20bx25.cern.txt"
  set filesPerJob = 1
  set nfiles = `cat $inputfilelist | wc | awk '{print $1}' `
  set maxjob=`python -c "print int($nfiles.0/$filesPerJob)-1"`
  echo "Sample " $sample " maxjob = " $maxjob


  foreach jobnumber(`seq 0 1 $maxjob`)
    echo "job " $jobnumber " out of " $maxjob
    bsub -q 1nd -o /afs/cern.ch/user/s/sixie/work/private/condor/res/Run2SUSY/RazorAnalysis/ElectronNtupler_${jobnumber}.out -J RazorAnalysis_ElectronNtupler_${jobnumber} /afs/cern.ch/work/s/sixie/public/releases/run2/CMSSW_7_2_0/src/RazorAnalyzer/scripts/runRazorJob_CERN.csh electronNtupler $inputfilelist 1 $filesPerJob $jobnumber ElectronNtuple_Prompt_${sample}_25ns.Job${jobnumber}Of${maxjob}.root /afs/cern.ch/user/s/sixie/work/public/Run2SUSY/ElectronNtuple/jobs/
    sleep 0.1
    bsub -q 1nd -o /afs/cern.ch/user/s/sixie/work/private/condor/res/Run2SUSY/RazorAnalysis/ElectronNtupler_${jobnumber}.out -J RazorAnalysis_ElectronNtupler_${jobnumber} /afs/cern.ch/work/s/sixie/public/releases/run2/CMSSW_7_2_0/src/RazorAnalyzer/scripts/runRazorJob_CERN.csh electronNtupler $inputfilelist 0 $filesPerJob $jobnumber ElectronNtuple_Fake_${sample}_25ns.Job${jobnumber}Of${maxjob}.root /afs/cern.ch/user/s/sixie/work/public/Run2SUSY/ElectronNtuple/jobs/
    sleep 0.1
    bsub -q 1nd -o /afs/cern.ch/user/s/sixie/work/private/condor/res/Run2SUSY/RazorAnalysis/ElectronNtupler_${jobnumber}.out -J RazorAnalysis_ElectronNtupler_${jobnumber} /afs/cern.ch/work/s/sixie/public/releases/run2/CMSSW_7_2_0/src/RazorAnalyzer/scripts/runRazorJob_CERN.csh electronNtupler $inputfilelist 11 $filesPerJob $jobnumber ElectronNtuple_PromptGenLevel_${sample}_25ns.Job${jobnumber}Of${maxjob}.root /afs/cern.ch/user/s/sixie/work/public/Run2SUSY/ElectronNtuple/jobs/
    sleep 0.1
  end

end


##########################
# Muon Ntupler
##########################
foreach sample( \
T1bbbb_1500
T1tttt_1500
TTJets \
DYJetsToLL \
)

  set inputfilelist="/afs/cern.ch/work/s/sixie/public/releases/run2/CMSSW_7_2_0/src/RazorAnalyzer/lists/razorNtuplerV1p4-25ns_v1_v1/${sample}_20bx25.cern.txt"
  set filesPerJob = 1
  set nfiles = `cat $inputfilelist | wc | awk '{print $1}' `
  set maxjob=`python -c "print int($nfiles.0/$filesPerJob)-1"`
  echo "Sample " $sample " maxjob = " $maxjob


  foreach jobnumber(`seq 0 1 $maxjob`)
    echo "job " $jobnumber " out of " $maxjob
    bsub -q 1nd -o /afs/cern.ch/user/s/sixie/work/private/condor/res/Run2SUSY/RazorAnalysis/MuonNtupler_${jobnumber}.out -J RazorAnalysis_MuonNtupler_${jobnumber} /afs/cern.ch/work/s/sixie/public/releases/run2/CMSSW_7_2_0/src/RazorAnalyzer/scripts/runRazorJob_CERN.csh muonNtupler $inputfilelist 1 $filesPerJob $jobnumber MuonNtuple_Prompt_${sample}_25ns.Job${jobnumber}Of${maxjob}.root /afs/cern.ch/user/s/sixie/work/public/Run2SUSY/MuonNtuple/jobs/
    sleep 0.1
    bsub -q 1nd -o /afs/cern.ch/user/s/sixie/work/private/condor/res/Run2SUSY/RazorAnalysis/MuonNtupler_${jobnumber}.out -J RazorAnalysis_MuonNtupler_${jobnumber} /afs/cern.ch/work/s/sixie/public/releases/run2/CMSSW_7_2_0/src/RazorAnalyzer/scripts/runRazorJob_CERN.csh muonNtupler $inputfilelist 0 $filesPerJob $jobnumber MuonNtuple_Fake_${sample}_25ns.Job${jobnumber}Of${maxjob}.root /afs/cern.ch/user/s/sixie/work/public/Run2SUSY/MuonNtuple/jobs/
    sleep 0.1
    bsub -q 1nd -o /afs/cern.ch/user/s/sixie/work/private/condor/res/Run2SUSY/RazorAnalysis/MuonNtupler_${jobnumber}.out -J RazorAnalysis_MuonNtupler_${jobnumber} /afs/cern.ch/work/s/sixie/public/releases/run2/CMSSW_7_2_0/src/RazorAnalyzer/scripts/runRazorJob_CERN.csh muonNtupler $inputfilelist 11 $filesPerJob $jobnumber MuonNtuple_PromptGenLevel_${sample}_25ns.Job${jobnumber}Of${maxjob}.root /afs/cern.ch/user/s/sixie/work/public/Run2SUSY/MuonNtuple/jobs/
    sleep 0.1
  end

end



##########################
# Jet Ntupler
##########################
foreach sample( \
TTJets \
)

  set inputfilelist="/afs/cern.ch/work/s/sixie/public/releases/run2/CMSSW_7_2_0/src/RazorAnalyzer/lists/razorNtuplerV1p4-25ns_v1_v1/${sample}_20bx25.cern.txt"
  set filesPerJob = 1
  set nfiles = `cat $inputfilelist | wc | awk '{print $1}' `
  set maxjob=`python -c "print int($nfiles.0/$filesPerJob)-1"`
  echo "Sample " $sample " maxjob = " $maxjob


  foreach jobnumber(`seq 0 1 $maxjob`)
    echo "job " $jobnumber " out of " $maxjob
    bsub -q 1nd -o /afs/cern.ch/user/s/sixie/work/private/condor/res/Run2SUSY/RazorAnalysis/JetNtupler_${jobnumber}.out -J RazorAnalysis_JetNtupler_${jobnumber} /afs/cern.ch/work/s/sixie/public/releases/run2/CMSSW_7_2_0/src/RazorAnalyzer/scripts/runRazorJob_CERN.csh jetNtupler $inputfilelist -1 $filesPerJob $jobnumber JetNtuple_Prompt_${sample}_25ns.Job${jobnumber}Of${maxjob}.root /afs/cern.ch/user/s/sixie/work/public/Run2SUSY/JetNtuple/jobs/
    sleep 0.1
  end

end

##########################
# Control Region Study
##########################
foreach sample( \
SMS-T1tttt_2J_mGl-1500_mLSP-100\
SMS-T1bbbb_2J_mGl-1500_mLSP-100\
SMS-T1tttt_2J_mGl-1200_mLSP-800\
SMS-T1bbbb_2J_mGl-1000_mLSP-900\
SMS-T1qqqq_2J_mGl-1400_mLSP-100\
SMS-T1qqqq_2J_mGl-1000_mLSP-800\
TTJets \
WJetsToLNu_HT100To200 \
WJetsToLNu_HT200To400 \
WJetsToLNu_HT400To600 \
WJetsToLNu_HT600ToInf \
DYJetsToLL_HT100To200 \
DYJetsToLL_HT200To400 \
DYJetsToLL_HT400To600 \
DYJetsToLL_HT600ToInf \
T_tW \
TBar_tW \
TToLeptons_s \
TBarToLeptons_s \
TToLeptons_t \
TBarToLeptons_t \
WZJetsTo3LNu \
TTWJets \
TTZJets \
QCDHT100To250 \
QCDHT250To500 \
QCDHT500To1000 \
QCDHT1000ToInf \
) 
  set inputfilelist="/afs/cern.ch/work/s/sixie/public/releases/run2/CMSSW_7_2_0/src/RazorAnalyzer/lists/razorNtuplerV1p4-25ns_v1_v1/${sample}_20bx25.cern.txt"
  set filesPerJob = 1
  set nfiles = `cat $inputfilelist | wc | awk '{print $1}' `
  set maxjob=`python -c "print int($nfiles.0/$filesPerJob)-1"`
  echo "Sample " $sample " maxjob = " $maxjob

  foreach jobnumber(`seq 0 1 $maxjob`)
    echo "job " $jobnumber " out of " $maxjob
    bsub -q 1nd -o /afs/cern.ch/user/s/sixie/work/private/condor/res/Run2SUSY/RazorAnalysis/RazorControlRegions_${jobnumber}.out -J RazorAnalysis_RazorControlRegions_${jobnumber} /afs/cern.ch/work/s/sixie/public/releases/run2/CMSSW_7_2_0/src/RazorAnalyzer/scripts/runRazorJob_CERN.csh RazorControlRegions $inputfilelist 4 $filesPerJob $jobnumber RazorControlRegions_${sample}_25ns.Job${jobnumber}Of${maxjob}.root /afs/cern.ch/user/s/sixie/work/public/Run2SUSY/RazorControlRegions/jobs/
    sleep 0.1
  end
  foreach jobnumber(`seq 0 1 $maxjob`)
    echo "job " $jobnumber " out of " $maxjob
    bsub -q 1nd -o /afs/cern.ch/user/s/sixie/work/private/condor/res/Run2SUSY/RazorAnalysis/VetoLeptonEfficiencyDileptonControlRegion_${jobnumber}.out -J RazorAnalysis_VetoLeptonEfficiencyDileptonControlRegion_${jobnumber} /afs/cern.ch/work/s/sixie/public/releases/run2/CMSSW_7_2_0/src/RazorAnalyzer/scripts/runRazorJob_CERN.csh VetoLeptonEfficiencyControlRegion $inputfilelist 0 $filesPerJob $jobnumber VetoLeptonEfficiencyDileptonControlRegion_${sample}_25ns.Job${jobnumber}Of${maxjob}.root /afs/cern.ch/user/s/sixie/work/public/Run2SUSY/VetoLeptonEfficiencyDileptonControlRegion/jobs/
    sleep 0.1
  end
  foreach jobnumber(`seq 0 1 $maxjob`)
    echo "job " $jobnumber " out of " $maxjob
    bsub -q 1nd -o /afs/cern.ch/user/s/sixie/work/private/condor/res/Run2SUSY/RazorAnalysis/VetoLeptonEfficiencySingleLeptonControlRegion_${jobnumber}.out -J RazorAnalysis_VetoLeptonEfficiencySingleLeptonControlRegion_${jobnumber} /afs/cern.ch/work/s/sixie/public/releases/run2/CMSSW_7_2_0/src/RazorAnalyzer/scripts/runRazorJob_CERN.csh VetoLeptonEfficiencyControlRegion $inputfilelist 1 $filesPerJob $jobnumber VetoLeptonEfficiencySingleLeptonControlRegion_${sample}_25ns.Job${jobnumber}Of${maxjob}.root /afs/cern.ch/user/s/sixie/work/public/Run2SUSY/VetoLeptonEfficiencySingleLeptonControlRegion/jobs/
    sleep 0.1
  end

end

