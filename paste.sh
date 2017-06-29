for i in `seq 1 20`
do
    cat thpsum$i.txt | python ave.py >> thpsumave.txt
    cat thpave$i.txt | python ave.py >> thpaveave.txt
    cat thpave$i.txt | python stdev.py >> thpstdev.txt
done

paste 1-20.dat thpsumave.txt > plotsum.txt
paste 1-20.dat thpaveave.txt > plotave.txt
paste 1-20.dat thpstdev.txt > plotstdev.txt
