ADDL_CPPFLAGS = -I../inc # The Boost library

# These variables are used in targets and/or prerequisites and must be
# defined before use:

SOURCES = $(wildcard *.cpp module_library/*.cpp framework/*.cpp \
            framework/ode_solver_library/*.cpp framework/utils/*.cpp)
OBJECTS = $(SOURCES:.cpp=.o)

TARGET_LIBRARY_NAME = BioCro
SHLIB_EXT = .so

SHLIB = $(TARGET_LIBRARY_NAME)$(SHLIB_EXT)

# Set the install name to an absolute path so that executables using
# the library can find it, no matter what directory they are run from:
SHLIB_INSTALL_NAME = $(shell pwd)/$(SHLIB)



library: $(SHLIB)

$(SHLIB): $(OBJECTS)
	@if test  "z$(OBJECTS)" != "z"; then \
	  echo $(SHLIB_LINK) -o $@ -install_name $(SHLIB_INSTALL_NAME) $(OBJECTS) $(ALL_LIBS); \
	  $(SHLIB_LINK) -o $@ -install_name $(SHLIB_INSTALL_NAME) $(OBJECTS) $(ALL_LIBS); \
	fi

.PHONY: library clean cleanall

# clean object files only
clean:
	@rm -f $(OBJECTS)

cleanall: clean
	@rm -f $(SHLIB)


################################################################################

# The code below is a slightly modified version of the method for generating and
# using dependency files presented at
# http://make.mad-scientist.net/papers/advanced-auto-dependency-generation.

DEPDIR := .deps
DEPSUBDIRS = $(DEPDIR)/module_library \
             $(DEPDIR)/framework \
             $(DEPDIR)/framework/ode_solver_library \
             $(DEPDIR)/framework/utils

DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.Td

POSTCOMPILE = mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d && touch $@

OUTPUT_OPTION = -o $@
COMPILE.cpp = $(CXX11) $(CXX11STD) $(DEPFLAGS) $(ALL_CPPFLAGS) $(ALL_CXXFLAGS) -c

$(OBJECTS) : %.o : %.cpp $(DEPDIR)/%.d | $(DEPSUBDIRS)
	$(COMPILE.cpp) $(OUTPUT_OPTION) $<
	$(POSTCOMPILE)

$(DEPSUBDIRS):
	@mkdir -p $@

DEPFILES := $(SOURCES:%.cpp=$(DEPDIR)/%.d)
$(DEPFILES):

include $(wildcard $(DEPFILES))

################################################################################

###### These settings are based on R's settings in $(R_HOME)/etc/Makeconf ######

CPPFLAGS = -I/usr/local/include
CXXFLAGS = $(CXX11FLAGS)
CXXPICFLAGS = $(CXX11PICFLAGS)
CXX11 = clang++ -mmacosx-version-min=10.13
CXX11FLAGS = -Wall -g -O2 $(LTO)
CXX11PICFLAGS = -fPIC
CXX11STD = -std=gnu++11
LDFLAGS = -L/usr/local/lib
LIBINTL=   -Wl,-framework -Wl,CoreFoundation
LTO =
SHLIB_CXX11LD = $(CXX11) $(CXX11STD)
SHLIB_CXX11LDFLAGS = -dynamiclib -Wl,-headerpad_max_install_names -undefined dynamic_lookup -single_module -multiply_defined suppress# $(CXX11FLAGS) $(CXX11PICFLAGS) $(LTO_LD)
SHLIB_LINK = $(SHLIB_CXX11LD) $(SHLIB_CXX11LDFLAGS) $(LDFLAGS)
ALL_CPPFLAGS =  -DNDEBUG $(ADDL_CPPFLAGS) $(CPPFLAGS) 
ALL_CXXFLAGS =  $(CXXPICFLAGS) $(CXXFLAGS)
ALL_LIBS = $(LIBINTL)
