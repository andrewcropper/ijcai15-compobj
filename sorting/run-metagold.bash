fname="results-metagold"
rm -rf $fname
mkdir $fname
# k=10

for i in {1..10}
do
  echo $i
  swipl --quiet --nodebug << % >> "$fname/program-$i.pl"
  [experiment].
  learn_metagold.
%
done

rm 'results-metagold/results*'

for i in {1..10}
do
  for n in 10 20 30 40 50 60 70 80 90 100
  do

    swipl --quiet --nodebug << % >> "$fname/results-$n-$i.pl"
    [experiment].
    ['$fname/program-$i'].
    do_test($n).
%
  done
done

# # for n in 10 20 30 40 50 60 70 80 90 100
# for n in 10
# do
#   python results.py $n 10
# done
