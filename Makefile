include Makefile.inc

DIRS = python
SRCDIR = src
INCLUDEDIR = include
INCLUDELIST= SimpleTable.h Linkdef.h

SCRATCHDIR = /tmp/

AUX = $(wildcard $(SRCDIR)/RazorAux*.cc)
ANALYSES = $(wildcard analyses/*.cc)
JETCORR = $(SRCDIR)/JetCorrectorParameters.cc $(SRCDIR)/SimpleJetCorrectionUncertainty.cc  $(SRCDIR)/JetCorrectionUncertainty.cc $(SRCDIR)/SimpleJetCorrector.cc $(SRCDIR)/FactorizedJetCorrector.cc 
EXECUTABLES = RazorRun NormalizeNtuple

all: $(addprefix $(SCRATCHDIR)/, $(EXECUTABLES))
	mv $(addprefix $(SCRATCHDIR)/, $(EXECUTABLES)) .
	@for d in $(DIRS); do (cd $$d; $(MAKE) $(MFLAGS) ); done
clean:
	@-rm $(EXECUTABLES)
	@rm -f $(SRCDIR)/*.o
	@for d in $(DIRS); do (cd $$d; $(MAKE) $(MFLAGS) clean ); done

$(INCLUDEDIR)/rootdict.cc:
	$(ROOTSYS)/bin/rootcint -f $@ -c $(CINTINCLUDES) -I$(INCLUDEDIR) $(INCLUDELIST)

$(SRCDIR)/SimpleTable.o: $(SRCDIR)/SimpleTable.cc 
	$(CXX) -c $^ $(CXXFLAGS) -I$(INCLUDEDIR) $(LDFLAGS) $(LIBS) -o $@ $(CXX11FLAGS)

$(SRCDIR)/RazorEvents.o: $(SRCDIR)/RazorEvents.C $(INCLUDEDIR)/RazorEvents.h
	$(CXX) $(SRCDIR)/RazorEvents.C $(CXXFLAGS) -I$(INCLUDEDIR) -c $(LDFLAGS) $(LIBS) -o $@ $(CXX11FLAGS)

$(SRCDIR)/RazorAnalyzer.o: $(SRCDIR)/RazorEvents.o $(SRCDIR)/RazorAnalyzer.cc
	$(CXX) $(SRCDIR)/RazorAnalyzer.cc $(CXXFLAGS) -I$(INCLUDEDIR) -c $(LDFLAGS) $(LIBS) -o $@ $(CXX11FLAGS)

$(SCRATCHDIR)/RazorRun: $(SRCDIR)/RazorEvents.o $(SRCDIR)/RazorAnalyzer.o $(ANALYSES) $(JETCORR) $(AUX) $(SRCDIR)/RazorRun.cc
	$(CXX) $(SRCDIR)/RazorRun.cc $(SRCDIR)/RazorEvents.o $(ANALYSES) $(JETCORR) $(AUX) $(SRCDIR)/RazorAnalyzer.o $(CXXFLAGS) -I$(INCLUDEDIR) $(LDFLAGS) $(LIBS) -o $@ $(CXX11FLAGS)

$(SCRATCHDIR)/NormalizeNtuple: $(SRCDIR)/SimpleTable.o $(SRCDIR)/NormalizeNtuple.cc $(INCLUDEDIR)/rootdict.o
	$(CXX) $^ $(CXXFLAGS) -I$(INCLUDEDIR) $(LDFLAGS) $(LIBS) -o $@ $(CXX11FLAGS)

MakePlots: $(SRCDIR)/SimpleTable.o ./macros/BackgroundStudies/OverlayKinematicPlots_Selected.C $(INCLUDEDIR)/rootdict.o
	$(CXX) $^ $(CXXFLAGS) -I$(INCLUDEDIR) $(LDFLAGS) $(LIBS) -o $@ $(CXX11FLAGS)
