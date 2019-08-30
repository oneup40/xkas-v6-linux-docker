#!/bin/bash

echo "testing on commit $1"

gitdir="$(mktemp -d)"
cp -r /tmp/z3randomizer $gitdir/

pushd $gitdir/z3randomizer >/dev/null
git clean -dfx || exit 1
git checkout -q $1 || exit 1
popd >/dev/null

linux_sfc="$(mktemp)"
orig_sfc="$(mktemp)"

cp /test/base.sfc $linux_sfc
cp /test/base.sfc $orig_sfc

cp /test/xkas-linux $gitdir/z3randomizer/
cp /test/xkas-orig.exe $gitdir/z3randomizer/

pushd $gitdir/z3randomizer >/dev/null
./xkas-linux LTTP_RND_GeneralBugfixes.asm $linux_sfc
wine ./xkas-orig.exe LTTP_RND_GeneralBugfixes.asm $orig_sfc
popd >/dev/null

linux_md5sum="$(mktemp)"
orig_md5sum="$(mktemp)"

md5sum - <$linux_sfc >$linux_md5sum
md5sum - <$orig_sfc >$orig_md5sum

exitcode=0

if diff $linux_md5sum $orig_md5sum ; then
    true
else
    echo "mismatch on commit $1"
    exitcode=1
fi

rm $linux_sfc $orig_sfc
rm $linux_md5sum $orig2_md5sum
rm -rf $gitdir

exit $exitcode
