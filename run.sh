#!zsh
for dir in ./challenges/*/
do
  dir=${dir%*/}
  pushd $dir
  ./run.sh
  popd
done
