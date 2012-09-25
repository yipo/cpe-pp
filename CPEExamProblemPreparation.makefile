
check-all:

# The default target.
# To check all the things needed to be checked.
# Use the `check' function to add tasks in.


VER = a b

# The suffixes indicating different versions of i/o files.
# There are usually 2 versions (a and b), and more versions are also allowed.
# A empty $(VER) means there is only one version
# (and we don't have to add any suffix to i/o files in this case).


define \n


endef

# The newline character.


# The `check' function.
# For each version of i/o of one problem,
# check whether all the output files are the same.

# - Syntax:
# $(call check,<problem>,<author-list>)
# <author-list> = [<author>...]

# - Result: (for each version <ver>)
# check-all: diff-<problem><ver>
# diff-<problem><ver>: io/<problem><ver>.out \
#   <problem>_<author><ver>.out... [tk/<problem><ver>.out]

define check_rule
check-all: diff-$1$2
diff-$1$2: io/$1$2.out $(foreach i,$3, $1_$i$2.out) $$(wildcard tk/$1$2.out)
endef

# The output file of toolkit presents, only when the file exist.

# Using 2 dollar signs before the `wildcard' function
# to avoid the file name becoming a comment.

check = $(if $(VER),                             \
  $(foreach ver,$(VER),                          \
    $(eval $(call check_rule,$1,\\\#$(ver),$2))),\
  $(eval $(call check_rule,$1,,$2)))


# Compare the first file (in prerequisites list) with the others by `diff'.

diff-%:
	@echo [$*]
	$(foreach i,$(call except_first,$^),-diff $(firstword $^) $(i)$(\n))

except_first = $(wordlist 2,$(words $1),$1)

