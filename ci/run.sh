#!/bin/bash
set -e
set -u

# checksums
sashimi_md5="b8ee3a415a80030ce92de15f40054a40"
sashimi_anno_md5="131d3ad1bb27c91693c342fbc0667d48"
sashimi_color_md5="41fee9e7e51a13a09c6d068cc6cb93cf"
sashimi_aggr_md5="50674d8812194bbb8f8f8ddab9238b3d"

fail() {
    echo ${1-""} >&2 && exit 1
}

# export GGSASHIMI_DEBUG=1

modes=( sashimi sashimi_anno sashimi_color sashimi_aggr )

for m in ${modes[@]}; do
    [[ $m == "sashimi_anno" ]] && anno="-g examples/annotation.gtf" || anno=""
    [[ $m == "sashimi_color" ]] && color="-C 3" || color=""
    [[ $m == "sashimi_aggr" ]] && aggr="-C 3 -O 3 -A mean_j" || aggr=""
    ./sashimi-plot.py $anno -b examples/input_bams.tsv -c chr10:27040584-27048100 $color $aggr
    md5=$(sed '/^\/\(.\+Date\|Producer\)/d' sashimi.pdf | md5sum | awk '$0=$1')
    [[ $md5 == $(eval 'echo $'$m'_md5') ]] || fail "== Wrong checksum for $m mode: $md5"
done

echo "== All checksums match"
echo "== DONE"

exit 0

