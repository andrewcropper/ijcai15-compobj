k=10
fname="results-metagold"
rm -rf $fname
mkdir $fname

for i in {1..10}
do
  echo $i
  swipl --quiet --nodebug << % >> "$fname/program-$i.pl"
  [experiment].
  learn_metagold.
%
done

for i in {1..10}
do
  for n in {1..10}
  do
    swipl --quiet --nodebug << % >> "$fname/results-$n-$i.pl"
    [experiment].
    ['$fname/program-$i'].
    do_test($n).
%
  done
done

# for n in {1..10}
# do
#   python results.py $n 11 $fname
# done