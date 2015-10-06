cd tests
for f in $(find . ! -name "luaunit.lua" -name '*.lua')
do
	/var/lib/jenkins/bin/lua "$f" -o tap >> $f".tap"
done
#/var/lib/jenkins/bin/lua  -o tap >> $f
#/var/lib/jenkins/bin/lua tests/test.lua -o tap
# lua test.lua -o tap
# test8
