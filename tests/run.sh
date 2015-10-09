cd tests
for f in $(find . ! -name "luaunit.lua" -name '*.lua')
do
	/var/lib/jenkins/bin/lua "$f" -o tap >> $f".tap"
done
