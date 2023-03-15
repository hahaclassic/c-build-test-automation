#!/bin/bash

# TODO
# Args separation
# Trimming w/ flags 



#touch /tmp/buffer
#src_data="data.txt"

#cat "$src_data" | { cat ; echo ; } |
#while read line; do
# echo $line

#done

 print_menu()
 {
     printf "Choose option:\n[pos] - Create positive data-pair\n[neg] - Create negative data-pair\n[q] - Quit.\n"

 }


 print_usage()
 {
     printf "./gen_data.sh\n[ -r | --rebuild ] - run ./build_release.sh\n[ -a | --auto ] - automate output\n[ -t=num | --trim=num] - trim numbers from output\n"
 }


trim_num()
{
    file_raw=/tmp/buffer
    file_trimmed=/tmp/buffer_trimmed

    regex="^[+-]?[0-9]+[.]?[0-9]*([e][+-]?[0-9]+)?$"

    cat "$file_raw" | { cat ; echo ; } |
    while read line; 
    do
        for word in $line; do
            if [[ $word =~ $regex ]]; then
                echo "$word" >> /tmp/buffer_trimmed
            fi
        done
    done

    echo "- Out : " >> "$readme_file"
    tr '\n' ' ' < /tmp/buffer_trimmed > "$file_out"
    cat "$file_out" >> "$readme_file"

    rm /tmp/buffer
    rm /tmp/buffer_trimmed
}


trim_str()
{
    string="Result:"

    flag_hook=false
    file_raw=/tmp/buffer
    file_trimmed=/tmp/buffer_trimmed

    cat "$file_raw" | { cat ; echo ; } |
    while read line
    do
        if [ "$flag_hook" = "true" ]; then
            echo "$line" >> /tmp/buffer_trimmed
        else
            for word in $line; do
                if [[ $word =~ $string ]]; then
                    (sed -n -e "s/^.*\(Result:.*\)/\1/p" <<< "$line") > /tmp/buffer_trimmed
                    flag_hook=true
                    break
                fi
            done
        fi
    done

    cat /tmp/buffer_trimmed

    echo "- Out : " >> "$readme_file"
    tr '\n' ' ' < /tmp/buffer_trimmed > "$file_out"
    cat "$file_out" >> "$readme_file"

    rm /tmp/buffer
    rm /tmp/buffer_trimmed
}


# Scan flags
flag_auto=""
flag_rebuild=""
flag_trimmer=""


for arg in $@; 
do
    case $arg in
        -a|--auto)
        flag_auto="true"
        shift
        ;;

        -r|--rebuild)
        flag_rebuild="true"
        shift
        ;;

        -t=*|--trim=*)
        [ "${arg#*=}" == "num" ] && flag_trimmer="-n"
        [ "${arg#*=}" == "str" ] && flag_trimmer="-s"
        shift 
        ;;

        *|-i|--info)
        print_usage
        exit 0
        shift 
        ;;
    esac
done 


# Rebuild handling
if [ -n "$flag_rebuild" ] && [ -f "./build_release.sh" ]; then
    ./build_release.sh
    chmod +x main.exe
elif [ -n "$flag_rebuild" ] && [ ! -f "./build_release.sh" ]; then
    printf "[ERR] : Unable to recompile (build_release not found)"
    exit 1
fi


# Check is needed file exist
func_tests_folder="./func_tests/"
data_folder="./func_tests/data"
readme_main="./func_tests/data/readme.md"
readme_ok="./func_tests/data/readme_ok.md"
readme_err="./func_tests/data/readme_err.md"


[ ! -d "$func_tests_folder" ] && mkdir func_tests
[ ! -d "$data_folder" ] && mkdir func_tests/data
[ ! -f "$readme_main" ] && touch func_tests/data/readme.md
[ ! -f "$readme_ok" ] && touch func_tests/data/readme_ok.md ; echo "# Positive cases:" > "$readme_ok"
[ ! -f "$readme_err" ] && touch func_tests/data/readme_err.md ; echo "# Negative cases: " > "$readme_err"


flag=1
while [ "$flag" == 1 ]; do
    print_menu
    read -p "Choice [pos/neg/q]? : " user_choice

    if [ "$user_choice" != "pos" ] && [ "$user_choice" != "neg" ] && [ "$user_choice" != "q" ]; then 
        printf "[WARNING] : Incorrect choice.\n" ; continue
    fi

    if [ "$user_choice" == "q" ]; then
        cat "$readme_ok" > "$readme_main"
        cat "$readme_err" >> "$readme_main"
        cp "$readme_main" ./func_tests
        flag="false"
        exit 0
    fi

    if [ "$user_choice" == "pos" ]; then
        count_old=$(find func_tests/data -type f -name "pos*in.txt" | wc -l)
        count_old=$(sed "s/ //g" <<< "$count_old")
        count=$((count_old + 1))
        file_prefix="pos_"
        data_status="positive"
        readme_file="$readme_ok"

    elif [ "$user_choice" == "neg" ]; then
        count_old=$(find func_tests/data -type f -name "neg*in.txt" | wc -l)
        count_old=$(sed "s/ //g" <<< "$count_old")
        count=$((count_old + 1))
        file_prefix="neg_"
        data_status="negative"
        readme_file="$readme_err"
    fi


    # Make data
    if [ "$count" -lt 10 ]; then
        count="0${count}"
    fi

    file_in="./func_tests/data/${file_prefix}${count}_in.txt"
    file_out="./func_tests/data/${file_prefix}${count}_out.txt"
    touch "$file_in"
    touch "$file_out"
    touch /tmp/buffer


    # Input
    read -p "Write a description for your ${count} ${data_status} test case: " description
    echo "### Test ${count}: [${description}]" >> "$readme_file"

    read -p "Write input data for your ${count} ${data_status} test case: " data
    echo "$data" | sed -r 's/[|]+/ /g' > "$file_in"
    echo "- In : " >> "$readme_file"
    echo "$data" | sed -r 's/[|]+/ /g' >> "$readme_file"

    # Output
    if [ -z "$flag_auto" ]; then
        read -p "Write output data for your ${count} ${data_status} test case: " out_data
        printf "%s\n" "$out_data" > "$file_out"
        echo "- Out : ${out_data}" >> "$readme_file"
    else
        exe_file="./*.exe"
        $exe_file < "$file_in" > /tmp/buffer
        [ -z "$flag_trimmer" ] && cat /tmp/buffer > "$file_out"

        # Execute only if flag is not empty
        if [ -n "$flag_trimmer" ]; then 
            printf "[DBG]: flag is not none"
            touch /tmp/buffer_trimmed
            [ "$flag_trimmer" == "-n" ] && trim_num
            [ "$flag_trimmer" == "-s" ] && trim_str
        fi 
    fi
done
