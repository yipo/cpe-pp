
check-all:

# The default target.
# To check all the things needed to be checked.
# Use the `check' function to add tasks in.


VER ?= a b

# The suffixes indicating different versions of i/o files.
# There are usually 2 versions (a and b), and more versions are also allowed.
# An empty $(VER) means there is only one version
# (in this case, we don't have to add any suffix to i/o files).


define \n


endef

# The newline character.


DIFF ?= diff

ifeq ($(findstring Win,$(OS)),)
  fix_path = $1
else
  fix_path = $(subst /,\,$1)
endif

# For Windows compatibility.


# The `auto_detect' command
# ---
# Instead of specifying the `check' function call one by one,
# `auto_detect' command find all the problems and the corresponding authors
# of each problem, then call the `check' function automatically.

ad_codes = $(notdir $(basename $(wildcard $(addprefix code/$1*.,c cpp java))))
ad_problems = $(sort $(foreach i,$(ad_codes),$(firstword $(subst _, ,$i))))
ad_authors = $(foreach i,$(call ad_codes,$1),$(lastword $(subst _, ,$i)))

auto_detect = $(foreach problem,$(ad_problems),\
  $(call check,$(problem),$(call ad_authors,$(problem))))


# The `check' function
# ---
# For each version of i/o of one problem,
# check whether all the output files are the same.

# - Syntax:
# $(call check,<problem>,<author-list>)
# <author-list> = [<author>...]

# - Result: (for each version <ver>)
# check-all: diff-<problem><ver>
# diff-<problem><ver>: io/<problem><ver>.out \
#   <problem>_<author><ver>.out... [tk/<problem><ver>.out]
# <problem>_<author><ver>.out...: <problem><ver>.in

vpath %.in io
vpath %.out io

# Where to find the i/o files.

define check_rule
check-all: diff-$1$2
diff-$1$2: $1$2.out $(foreach i,$3,$1_$i$2.out) $$(wildcard tk/$1$2.out)
$(foreach i,$3,$1_$i$2.out): $1$2.in
endef

# $1: <problem>, $2: <#ver>, $3: <author-list>

# The output file of toolkit presents, only when the file exist.

# Using 2 dollar signs before the `wildcard' function
# to avoid the file name becoming a comment.

check = $(if $(VER),                             \
  $(foreach ver,$(VER),                          \
    $(eval $(call check_rule,$1,\\\#$(ver),$2))),\
  $(eval $(call check_rule,$1,,$2)))


# The `diff-%' rule
# ---
# Compare the first file (in prerequisites list) with the others by `diff'.

diff-%:
	@echo [$*]
	$(foreach i,$(call except_first,$^),\
		-$(DIFF) $(call fix_path,$(firstword $^) $i)$(\n))

except_first = $(wordlist 2,$(words $1),$1)


# The rules of generating .out files
# ---

define fout_rule
%$1.out: %.exe
	> $$@ < $$(word 2,$$^) $(call fix_path,./$$<)
%$1.out: %.class
	> $$@ < $$(word 2,$$^) java $$*
endef

# There are 2 ways to generate an output file.
# $1: the version suffix (with `#') which can be empty.

# The file extension `.exe' is needed to generate the .out file
# via 2 implicit rules from .c/.cpp source code.

$(if $(VER),                            \
  $(foreach ver,$(VER),                 \
    $(eval $(call fout_rule,\#$(ver)))),\
  $(eval $(call fout_rule,)))

# Generate the `fout_rule's for each version of i/o.


# The rules of generating .exe and .class
# ---

vpath %.c code
vpath %.cpp code
vpath %.java code

# Where to find the source codes.

.SECONDARY:

# Avoid the intermediate files being killed after making.

%.exe: %.c
	$(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@

%.exe: %.cpp
	$(LINK.cpp) $^ $(LOADLIBES) $(LDLIBS) -o $@

# These 2 commands are the same as the built-in rules from `make -p'.

%.class: %.java
	javac -d . $<

# There is no built-in rule for java source codes so we write our own.
# Use `-d .' to put the .class at current directory not at code/.


# clean
# ---

clean:
	$(RM) *.out *.exe *.class

