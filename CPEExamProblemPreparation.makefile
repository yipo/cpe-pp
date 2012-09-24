
define \n


endef

# The newline character.


# Compare the first file (in prerequisites list) with the others by `diff'.

diff-%:
	@echo [$*]
	$(foreach i,$(call except_first,$^),-diff $(firstword $^) $(i)$(\n))

except_first = $(wordlist 2,$(words $1),$1)

