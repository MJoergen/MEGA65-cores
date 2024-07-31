set cur_dir [exec pwd]
cd ../../m2m-rom/
exec ./make_rom.sh <@stdin >@stdout 2>@stderr
cd $cur_dir

