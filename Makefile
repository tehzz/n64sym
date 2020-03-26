CC:=g++
CFLAGS:=-static -O3 -ffunction-sections -fdata-sections -fno-ident

LD:=g++
LDFLAGS:=-s -Wl,--gc-sections,-lm

# OS Conditional Checks
ifeq ($(OS),WINDOWS_NT)
	CFLAGS += -s -I./include
else
	UNAME := $(shell uname -s)
	
	ifeq ($(UNAME),Darwin)
		LDFLAGS:=-Wl,-dead_strip,-lm
	else
		CFLAGS += -s 
	endif
endif

SDIR:=src
ODIR:=obj
BDIR:=bin

SFILES=$(wildcard $(SDIR)/*.cpp)
OFILES=$(patsubst $(SDIR)/%.cpp,$(ODIR)/%.o,$(SFILES))

TARGET=$(BDIR)/n64sym

$(TARGET): $(OFILES) | $(BDIR)
	$(LD) $(LDFLAGS) $(OFILES) -o $(TARGET)

$(ODIR)/%.o: $(SDIR)/%.cpp | $(ODIR)
	$(CC) $(CFLAGS) -c $^ -o $@

$(ODIR):
	mkdir $(ODIR)

$(BDIR):
	mkdir $(BDIR)

clean:
	rm -f n64sym
	rm -rf $(ODIR)
	rm -rf $(BDIR)

.PHONY: n64sym clean