
# Dependencies
deps:=parsec yesod yesod-static split 

ghc:=ghc
packages:=-package parsec -package yesod -package yesod-static -package split 
flags:=-XViewPatterns $(packages) 

# Vars for json conversion
json.out:=json.out
json.in:=JSON.hs
csv.in:=input.csv

wagon.dir:=Wagon
main.in:=Main.hs
main.out:=./challenge 

server.in:=Server.hs
server.out:=server

vars.1:=1000


############
# Gather list of all files of a particular filetype
# Example:
# $(call all_files,.,*.hs) -- Gather all .hs files in subdirectories
#                          -- of current folder. 
all_files=$(wildcard $(1)/$(2)) $(foreach i,$(wildcard $(1)/*), $(call all_files,$(i),$(2))) 



############
# Create JSON File from CSV (unfinished...) 
$(json.out): $(json.in) 
	@echo 'Compiling $@...'
	ghc -o $@ $< $(call all_files,$(wagon.dir),*.hs) 

json: $(json.out) 
	@echo 'Creating json from $(csv.in)...'
	./$(json.out) $(csv.in) 



############ 
# Make Challenge 1 
build:
	@echo 'Compiling...' 
	@$(ghc) -o $(main.out) $(call all_files,$(wagon.dir),*.hs) $(main.in) $(flags) 


# Run previous Challenge 
run: build 
	@./$(main.out) 



############
# Create Yesod server
$(server.out): $(server.in) 
	@echo 'Compiling $@...'
	@ghc -o $@ $< $(flags) 

# Run server 
serve: $(server.out)
	@echo 'Running server...'
	@./$< 



############
# Utilities 

# Run generator
gen: 
	@docs/generator $(vars.1) 


# Run generator input through program 
test.1: build 
	@echo 'Running Generator...'
	@docs/generator $(vars.1) | ./$(main.out)


# Install dependencies
deps:
	@echo 'Installing dependencies...'
	@$(foreach i,$(deps),cabal install $(i);) 


# Clean project 
clean:
	@echo 'Removing files...'
	@rm -rvf \
	    $(main.out) \
	    $(json.out) \
	    $(server.out) \
	    $(call all_files,.,*.hi) \
	    $(call all_files,.,*.o) \
	    $(call all_files,.,*.dyn_o) \
	    $(call all_files,.,*.dyn_hi) \
	    $(call all_files,.,*.aes) 

.PHONY: c1 c2 

