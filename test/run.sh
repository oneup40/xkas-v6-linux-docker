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

linux_stdout="$(mktemp)"
linux_stderr="$(mktemp)"

orig_stdout="$(mktemp)"
orig_stderr="$(mktemp)"

pushd $gitdir/z3randomizer >/dev/null
./xkas-linux LTTP_RND_GeneralBugfixes.asm $linux_sfc >linux_stdout 2>linux_stderr
wine ./xkas-orig.exe LTTP_RND_GeneralBugfixes.asm $orig_sfc >orig_stdout 2>orig_stderr
popd >/dev/null

linux_md5sum="$(mktemp)"
orig_md5sum="$(mktemp)"

md5sum - <$linux_sfc >$linux_md5sum
md5sum - <$orig_sfc >$orig_md5sum

exitcode=0

if diff $linux_md5sum $orig_md5sum ; then
    true
else
    echo "ROM mismatch on commit $1"
    exitcode=1
fi

md5sum - <$linux_stdout > $linux_md5sum
md5sum - <$orig_stdout > $orig_md5sum

if diff $linux_md5sum $orig_md5sum ; then
    true
else
    echo "stdout mismatch on commit $1"
    exitcode=1
fi

md5sum - <$linux_stderr > $linux_md5sum
md5sum - <$orig_stderr > $orig_md5sum

if diff $linux_md5sum $orig_md5sum ; then
    true
else
    echo "stderr mismatch on commit $1"
    exitcode=1
fi

rm $linux_sfc $orig_sfc
rm $linux_stdout $orig_stdout
rm $linux_stderr $orig_stderr
rm $linux_md5sum $orig_md5sum
rm -rf $gitdir

exit $exitcode
