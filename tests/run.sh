cd tests
for f in *.lua
do
	if [ "$f" != "luaunit.lua" ]; then /var/lib/jenkins/bin/lua "$f" -o tap >> $f".tap"; fi;
done
#/var/lib/jenkins/bin/lua  -o tap >> $f
#/var/lib/jenkins/bin/lua tests/test.lua -o tap
# lua test.lua -o tap
# test8
