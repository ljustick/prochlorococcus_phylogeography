for sample in $(ls *.fa);
do

echo "$sample"
wc -l $sample

done

echo 'job finished'