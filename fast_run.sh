#!/bin/bash
if [[ $1 == "--help" ]]; then
    echo "To run tests for all tasks, type <./fast_run.sh run=all>"
    echo "To run tests for one task, specify its number: <./fast_run.sh run=01>"
    echo "If you do not need statistics, specify the -f flag"
    echo "Specify --help for help"
    exit 0
fi

if [[ $1 == "-f" || $2 == "-f" ]]; then
    while IFS='' read -r line;
        do func_tests+=("$line");
    done < <(find . -name "func_tests.sh" | sort -k 1.7n)
else
    while IFS='' read -r line;
        do func_tests+=("$line");
    done < <(find . -name "stats.sh" | sort -k 1.7n)
fi

if [[ $1 =~ "run=" || $2 =~ "run=" ]]; then
    if [[ $1 == "run=all" || $2 == "run=all" ]]; then
        if [[ ${#func_tests[@]} -eq ${#func_tests[@]} ]]; then
            count=0
            for ((i=0; i<${#func_tests[@]}; i++))
            do  
                (( count++ ))
                echo -e "\033[36mTASK\033[0m" $count
                cd "${func_tests[$i]:0:14}"
                ./build_release.sh
                cd ../

                cd "${func_tests[$i]:0:34}"
                ./${func_tests[$i]:34:42}
    
                cd ../../../
                echo ""
            done
        else
            echo "Error! No one func_tests or stats file"
        fi
    else
        flag=0
        while IFS='' read -r line;
        do
            if [[ ${line:(-5):2} == ${2:4:2} || ${line:(-5):2} == ${1:4:2} ]]; then
                cd $line
                flag=1
                break
            fi
        done < <(find -name "lab_*_*_*")
        
        if [[ $flag -eq 0 && ! -z $2 && ! ( $2 =~ "run=all" ) ]]; then
            echo "There is no task ${2:4:2}"
            exit 1
        elif [[ $flag -eq 0 && ! -z $1 && ! ( $1 =~ "run=all" ) ]]; then
            echo "There is no task ${1:4:2}"
            exit 1
        elif [[ $flag -eq 0 ]]; then
            echo "Incorrect parameter. Try ./fast.sh run=<num_of_task>"
            exit 1
        fi

        if [[ ! -e ./build_release.sh ]]; then 
            echo "There is no ./build_release.sh in this directory"
            exit 1
        fi

        if [[ ! -e ./func_tests/scripts ]]; then
            echo "There is no ./func_tests/scripts in this directory"
            exit 1
        fi

        if [[ $1 == "-f" && ! -e ./func_tests/scripts/func_tests.sh ]]; then
            echo "There is no ./func_tests.sh"
            exit 1
        elif [[ ! -e ./func_tests/scripts/stats.sh ]]; then
            echo "There is no ./stats.sh"
            exit 1
        fi
        
        ./build_release.sh
        cd ./func_tests/scripts
        ./${func_tests[1]:34:42}
        cd ../../../
    fi
else
    echo "Error! Enter 'run=all' for testing all files or 'run=<task_number>' for testing task <task_number>" 
fi
