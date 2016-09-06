# prompting functions: manage user interface and info prompting

prompt_port() {
    local var_check=false
    while [ $var_check = false ]
    do
        read -p "Enter port for $1: " -n 6 -r
        port=$REPLY
        var_check="true"
        if [ "$(check_port "$port")" == "false" ]; then
            var_check="false"
            echo
            echo -e "Error : wrong value"
        fi
    done
}

prompt_ports() {
    echo "You will be asked for ports:"
    prompt_port "master port (in cluster.ini)"
    master_port=$port
    prompt_port "server port (in Master/server.ini)"
    master_server_port=$port
    prompt_port "master server port (in Master/server.ini)"
    master_master_server_port=$port
    prompt_port "authentication port (in Master/server.ini)"
    master_authentication_port=$port
    if [ $caves_enabled = "true" ]; then
        prompt_port "server port (in Caves/server.ini)"
        caves_server_port=$port
        prompt_port "master server port (in Caves/server.ini)"
        caves_master_server_port=$port
        prompt_port "authentication port (in Master/server.ini)"
        caves_authentication_port=$port
    fi
}

prompt_max_players() {
    local var_check=false
    while [ $var_check = false ]
    do
        read -p "Enter the maximum number of players: " -n 3 -r
        var_check=true
        [[ "$REPLY" =~ ^[0-9]+$ ]] || var_check=false
        (( REPLY >= 1 && REPLY <= 64 )) || var_check=false
        if [ $var_check = false ]; then
            echo
            echo -e "Error : wrong value"
        fi
    done
    echo
    max_players=$REPLY
}

prompt_enable_caves() {
    read -p "Do you wish to enable caves?[Y/n]" -n 1 -r
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        caves_enabled="false"
        shard="false"
        echo
    else
        caves_enabled="true"
        shard="true"
    fi
}

prompt_pvp() {
    read -p "Do you wish to enable pvp?[y/N]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        pvp="true"
        echo
    else
        pvp="false"
    fi
}

prompt_pause_when_empty() {
    read -p "Do you wish to pause the server when no one is connected?[Y/n]" -n 1 -r
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        pause_when_empty="false"
        echo
    else
        pause_when_empty="true"
    fi
}

prompt_console() {
    read -p "Do you wish to enable console on your dedicated server?[Y/n]" -n 1 -r
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        console="false"
        echo
    else
        console="true"
    fi
}

prompt_gamemode() {
    var_check=false
    while [ $var_check = false ]
    do
        echo "Choose your gamemode:"
        echo
        echo " [1] Endless"
        echo " [2] Survival"
        echo " [3] Wilderness"
        echo
        read -p "Chosen gamemode: " -n 1 -r
        case $REPLY in
            "1")
            gamemode="endless"
            var_check=true
            ;;
            "2")
            gamemode="survival"
            var_check=true
            ;;
            "3")
            gamemode="wilderness"
            var_check=true
            ;;
            *)
            echo "Error : wrong value"
            echo
            var_check=false
        esac
        echo
    done
}

prompt_intention() {
    var_check=false
    while [ $var_check = false ]
    do
        echo "Choose your intention:"
        echo
        echo " [1] Cooperative"
        echo " [2] Social"
        echo " [3] Competitive"
        echo " [4] Madness"
        echo
        read -p "Chosed intention: " -n 1 -r
        case $REPLY in
            "1")
            intention="cooperative"
            var_check=true
            ;;
            "2")
            intention="social"
            var_check=true
            ;;
            "3")
            intention="competitive"
            var_check=true
            ;;
            "4")
            intention="madness"
            var_check=true
            ;;
            *)
            echo "Error : wrong value"
            echo
            var_check=false
        esac
        echo
    done
}

prompt_password() {
    var_check=false
    while [ $var_check = false ]
    do
        read -s -p "Give your server a password:" -r
        password=$REPLY
        echo
        read -s -p "Type it again" -r
        if [ $REPLY = $password ]; then
            var_check=true
            echo
        else
            echo -e "\nPasswords doesnt match"
        fi
    done
}

prompt_cluster_name() {
    local var_check=false
    local cluster_name_checker
    while [ $var_check = false ]
    do
        var_check="true"
        read -p "Give your server a name (name of your cluster on steam server browser) : " -r
        cluster_name_checker=$REPLY
        cluster_name=${cluster_name_checker//[^a-zA-Z0-9_]/}
        if [ "$cluster_name_checker" != "$cluster_name" ] || [ "$cluster_name_checker" = "" ]; then
            var_check="false"
            echo
            echo -e "Error : cluster_name should not be empty and can only contain alphanumics and underscores"
        else 
            echo -e "Your server will be displayed as $cluster_name"
        fi

    done
}

prompt_cluster_id() {

    local var_check=false
    local cluster_id_checker
    while [ $var_check = false ]
    do
        var_check="true"
        read -p "Give your cluster an ID (folder name of you cluster) : " -r
        cluster_id_checker=$REPLY
        cluster_id=${cluster_id_checker//[^a-zA-Z0-9_]/}
        if [ "$cluster_id_checker" != "$cluster_id" ] || [ "$cluster_id_checker" = "" ]; then
            var_check="false"
            echo
            echo -e "Error : cluster_id should not be empty and can only contain alphanumics and underscores"
        else 
            echo -e "Your cluster folder will be $cluster_id"
        fi

    done
}

prompt_cluster_creation() {
    read -p "Do you wish to create a new cluster?[y/N]" -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    echo
}

prompt_intro_create_server() {
    echo
    echo
    echo "###########################################################################"
    echo "#               DoNotStarveTogetherDedicated Cluster Creator              #"
    echo "###########################################################################"
    echo
    echo "You are about to create 3 ini files, to setup your new cluster, which are:"
    echo " => $1cluster.ini"
    echo " => $1Master/server.ini"
    echo " => $1Caves/server.ini"
    echo
    echo "You will have to enter 7 ports (only 4 if you dont use caves) which are:"
    echo " => master port (in cluster.ini)"
    echo " => server port (in Master/server.ini)"
    echo " => master server port (in Master/server.ini)"
    echo " => authentication port (in Master/server.ini)"
    echo " => server port (in Caves/server.ini) (Caves Only)"
    echo " => master server port (in Caves/server.ini) (Caves Only)"
    echo " => authentication port (in Caves/server.ini) (Caves Only)"
    echo
}

prompt_all () {
    prompt_intro_create_server $working_directory
    prompt_cluster_creation
    prompt_cluster_id
    prompt_cluster_name
    prompt_password
    prompt_max_players
    prompt_gamemode
    prompt_intention
    prompt_enable_caves
    prompt_pvp
    prompt_pause_when_empty
    prompt_console
    prompt_ports
}

# table init and prepare functions: fills tables for later use

init_defaults() {
    cfg_parser "./../config.ini" "default_values"
}

init_missing_args_array() {
    missing_args_array[0]="-gamemode"
    missing_args_array[1]="-intention"
    missing_args_array[2]="-password"
    missing_args_array[3]="-PWE"
    missing_args_array[4]="-caves"
    missing_args_array[5]="-console"
    missing_args_array[6]="-pvp"
    missing_args_array[7]="-id"
    missing_args_array[8]="-name"
    missing_args_array[9]="-max_players"
    missing_args_array[10]="-mp"
    missing_args_array[11]="-msp"
    missing_args_array[12]="-mmsp"
    missing_args_array[13]="-map"
    missing_args_array[14]="-csp"
    missing_args_array[15]="-cmsp"
    missing_args_array[16]="-cap"
}

prepare_final_vars_array() {
    final_vars_array[0]="$gamemode"
    final_vars_array[1]="$intention"
    final_vars_array[2]="$password"
    final_vars_array[3]="$pause_when_empty"
    final_vars_array[4]="$caves_enabled"
    final_vars_array[5]="$console"
    final_vars_array[6]="$pvp"
    final_vars_array[7]="$cluster_id"
    final_vars_array[8]="$cluster_name"
    final_vars_array[9]="$max_players"
    final_vars_array[10]="$master_port"
    final_vars_array[11]="$master_server_port"
    final_vars_array[12]="$master_master_server_port"
    final_vars_array[13]="$master_authentication_port"
    final_vars_array[14]="$caves_server_port"
    final_vars_array[15]="$caves_master_server_port"
    final_vars_array[16]="$caves_authentication_port"
}

prepare_final_vars_name_array() {
    final_vars_name_array[0]="gamemode"
    final_vars_name_array[1]="intention"
    final_vars_name_array[2]="password"
    final_vars_name_array[3]="pause_when_empty"
    final_vars_name_array[4]="caves_enabled"
    final_vars_name_array[5]="console"
    final_vars_name_array[6]="pvp"
    final_vars_name_array[7]="cluster_id"
    final_vars_name_array[8]="cluster_name"
    final_vars_name_array[9]="max_players"
    final_vars_name_array[10]="master_port"
    final_vars_name_array[11]="master_server_port"
    final_vars_name_array[12]="master_master_server_port"
    final_vars_name_array[13]="master_authentication_port"
    final_vars_name_array[14]="caves_server_port"
    final_vars_name_array[15]="caves_master_server_port"
    final_vars_name_array[16]="caves_authentication_port"
}

# parsing and reading function : read files or arguments and parses info from it

cfg_parser() {
    local i=0
    local item
    local section
    local section_begin
    local section_end="false"
    ini="$(<$1)"                # read the file
    #ini="${ini//[/\[}"          # escape [
    #ini="${ini//]/\]}"          # escape ]
    IFS=$'\n' && ini=( ${ini} ) # convert to line-array
    section="[$2]"
    for item in "${ini[@]}"; do
        if [ $section == "$item" ]; then
            section_begin="$i"
        else
            ((i++))
        fi
    done
    i=0
    for item in "${ini[@]}"; do
        if [ $i -le $section_begin ]; then
            ini[$i]=""
        elif [ "$section_end" == "true" ]; then
            ini[$i]=""
        elif [[ $item == *"["* ]]
        then
            ini[$i]=""
            section_end="true"
        fi
        ((i++))
    done
    ini=( ${ini[*]//;*/} )      # remove comments with ;
    ini=( ${ini[*]/\[*/} )      # remove section with [
    ini=( ${ini[*]/\    =/=} )  # remove tabs before =
    ini=( ${ini[*]/=\   /=} )   # remove tabs be =
    ini=( ${ini[*]/\ =\ /=} )   # remove anything with a space around =
    ini=( ${ini[*]/=/=\( } )    # convert item to array
    ini=( ${ini[*]/%/ \)} )     # close array parenthesis
    ini=( ${ini[*]/%\} \)/\}} ) # remove extra parenthesis
    eval "$(echo "${ini[*]}")" # eval the result
    shard=$caves_enabled
    
}

args_parser() {
    case $1 in
        "-mp")
            shift
            master_port=$1
            shift
            ;;
        "-msp")
            shift
            master_server_port=$1
            shift
            ;;
        "-mmsp")
            shift
            master_master_server_port=$1
            shift
            ;;
        "-map")
            shift
            master_authentication_port=$1
            shift
            ;;
        "-csp")
            shift
            caves_server_port=$1
            shift
            ;;
        "-cmsp")
            shift
            caves_master_server_port=$1
            shift
            ;;
        "-cap")
            shift
            caves_authentication_port=$1
            shift
            ;;
        "-gamemode")
            shift
            gamemode=$1
            shift
            ;;
        "-intention")
            shift
            intention=$1
            shift
            ;;
        "-password")
            shift
            password=$1
            shift
            ;;
        "-PWE")
            shift
            pause_when_empty=$1
            shift
            ;;
        "-caves")
            shift
            shard=$1
            caves_enabled=$1
            shift
            ;;
        "-console")
            shift
            console=$1
            shift
            ;;
        "-id")
            shift
            cluster_id=$1
            shift
            ;;
        "-name")
            shift
            cluster_name=$1
            shift
            ;;
        "-max_players")
            shift
            max_players=$1
            shift
            ;;
        "-pvp")
            shift
            pvp=$1
            shift
            ;;
        *)
            echo "Error : wrong option => $1"
            echo
            exit
    esac
    ((i++))

}

read_args() {
    echo -e "translating arguments..." 
    init_missing_args_array
    prepare_final_vars_array
    shift
    i=0
    while [ "$1" != "" ]
    do
        for (( e=0; e<=$i; e++ ))
        do
            if [ "${arg_array[$e]}" = "$1" ]; then
                echo "Error: already entered arg \"$1\""
                exit
            fi   
        done
        for (( e=0; e<=16; e++ ))
        do
            if [ "${missing_args_array[$e]}" = "$1" ]; then
                missing_args_string=$(echo "${missing_args_array[*]:0:$e}" && echo "${missing_args_array[*]:$(($e + 1))}")
                IFS=$'\n' && missing_args_array=( ${missing_args_string} )
                final_vars_string=$(echo "${final_vars_array[*]:0:$e}" && echo "${final_vars_array[*]:$(($e + 1))}")
                IFS=$'\n' && final_vars_array=( ${final_vars_string} )
            fi  
        done
        arg_array[$i]=$1
        args_parser $@
        shift
        shift
    done
    echo -e "done"
    if [ "${missing_args_array[0]}" != "" ]; then
        if [ $caves_enabled = "true" ] || [ $(check_if_caves_port ${missing_args_array[0]}) = "false" ]; then
            echo -e "The following arguments are missing and will be replaced by default values : "
            e=0
            while [ "${missing_args_array[$e]}" != "" ] && ( [ $(check_if_caves_port ${missing_args_array[$e]}) = "false" ] || [ $caves_enabled = "true" ] )
            do
                echo -e "=> ${missing_args_array[$e]} argument will be filled with \"${final_vars_array[$e]}\""
                ((e++))
            done
        fi
    fi
}

# checking functions : test values inputed by the user (in config.ini, arguments or prompted infos)

check_if_caves_port() {
    case $1 in
        "-csp"|"-cmsp"|"-cap")
            echo "true"
            ;;
        *)
            echo "false"
            ;;
    esac
}

check_port() {
    local var_check=true
    local port=$1
    [[ "$port" =~ ^[0-9]+$ ]] || var_check=false
    (( port >= 0 && port <= 65535 )) || var_check=false
    if [ $var_check = false ]; then
        echo "false"
    else
        echo "true"
    fi
}

check_binary_value() {
    case $1 in
        "true"|"false")
        echo "true"
        ;;
        *)
        echo "false"
    esac

}

check_global() {
    local item
    local array_end=16
    local i=0
    local global_var_check="true"
    init_missing_args_array
    prepare_final_vars_array
    prepare_final_vars_name_array
    if [ "$caves_enabled" = "false" ]; then
         array_end=13
    fi
    local array_offset=$(($array_end + 1))
    for item in "${final_vars_array[@]:0:$array_offset}"; do
        if [ "$item" = "" ]; then
            echo "Error : ${final_vars_name_array[$i]} is missing in config.ini ( under default_values section ) or as parameters ( ${missing_args_array[$i]} )"
            global_var_check="false"
        fi
        ((i++))
    done
    
    
    i=10
    array_offset=$(($array_end + 1 - $i))
    for item in "${final_vars_array[@]:$i:$array_offset}"; do
        if [ "$(check_port "${final_vars_array[$i]}")" == "false" ]; then
            echo "Error : ${final_vars_name_array[$i]} is set as ${final_vars_array[$i]} which is wrong for a port number"
            global_var_check="false"
        fi
        ((i++))
    done

    
    case $gamemode in
        "endless"|"survival"|"wilderness")
            ;;
        *)
            echo "Error : $gamemode is wrong as a gamemode value"
            global_var_check="false"
        ;;
    esac
        
    case $intention in
        "cooperative"|"social"|"competitive"|"madness")
            ;;
        *)
            echo "Error : $intention is wrong as an intention value"
            global_var_check="false"
    esac
    
    i=3
    array_offset=4
    for item in "${final_vars_array[@]:$i:$array_offset}"; do
        if [ "$(check_binary_value "${final_vars_array[$i]}")" = "false" ]; then
            echo "Error : ${final_vars_name_array[$i]} is not set as true or false in config.ini ( under default_values section ) or as parameters ( ${missing_args_array[$i]} )"
            global_var_check="false"
        fi
        ((i++))
    done  

    local var_check=true
    [[ "$max_players" =~ ^[0-9]+$ ]] || var_check=false
    (( max_players >= 1 && max_players <= 64 )) || var_check=false
    if [ $var_check = false ]; then
        echo -e "Error : $max_players is not a good value ( 0-64 ) for max_players in config.ini ( under default_values section ) or as parameters ( -max_players )"
        global_var_check="false"
    fi
    
    
    
    if [ "$global_var_check" = "false" ]; then
        echo -e "exiting...."
        exit
    fi
    
    cluster_id=${cluster_id//[^a-zA-Z0-9_]/}
    echo "Your server folder will be Cluster_$cluster_id"
    
    cluster_name=${cluster_name//[^a-zA-Z0-9_]/}
    echo "Your server will be displayed as $cluster_name"
}

# Files and folder functions : manage and fills folders and files (will become and API later

create_directory() {
    path_to_directory="./$1/"
    if [ -d "$path_to_direcory" ]; then
        echo "$1 directory already exists"
    else
        mkdir -v $1
    fi
}

fill_worldgen_lua() {
    echo -e "return {" >> "$1"
    echo -e "       override_enabled = true," >> "$1"
    echo -e "       preset = \"DST_CAVE\"," >> "$1"
    echo -e "}" >> "$1"

}

fill_cluster_ini() {
    echo -e "[GAMEPLAY]" >> "${10}"
    echo -e "game_mode = $1" >> "${10}"
    echo -e "max_players = $2" >> "${10}"
    echo -e "pvp = $3" >> "${10}"
    echo -e "pause_when_empty = $4" >> "${10}"
    echo -e "\n" >> "${10}"
    echo -e "[NETWORK]" >> "${10}"
    echo -e "lan_only_cluster = false" >> "${10}"
    echo -e "offline_cluster = false" >> "${10}"
    echo -e "cluster_description =" >> "${10}"
    echo -e "cluster_name = $5" >> "${10}"
    echo -e "server_intention = $6" >> "${10}"
    echo -e "cluster_password = ${11}" >> "${10}"
    echo -e "fill_cluster_initention = $6" >> "${10}"
    echo -e "\n" >> "${10}"
    echo -e "[MISC]" >> "${10}"
    echo -e "console_enabled = $7" >> "${10}"
    echo -e "\n" >> "${10}"
    echo -e "[SHARD]" >> "${10}"
    echo -e "shard_enabled = $8" >> "${10}"
    echo -e "bind_ip = 127.0.0.1" >> "${10}"
    echo -e "master_ip = 127.0.0.1" >> "${10}"
    echo -e "master_port = $9" >> "${10}"
    echo -e "cluster_key = defaultPass" >> "${10}"
}

fill_server_ini() {
    echo -e "[NETWORK]" >> "$5"
    echo -e "server_port =  $1" >> "$5"
    echo -e "\n" >> "$5"
    echo -e "[SHARD]" >> "$5"
    if [ $4 = true ]; then
        echo -e "is_master = true" >> "$5"
    else
        echo -e "is_master = false" >> "$5"
        echo -e "name = Caves" >> "$5"
    fi
    echo -e "\n" >> "$5"
    echo -e "[STEAM]" >> "$5"
    echo -e "master_server_port = $2" >> "$5"
    echo -e "authentication_port = $3" >> "$5"
}

fill_server_ini_wraper() {
    create_directory "$1"
    path_to_file="./$1/server.ini"
    if [ $1 = "Master" ]; then
        fill_server_ini "$master_server_port" "$master_master_server_port" "$master_authentication_port" true "$path_to_file"
    else
        fill_server_ini "$caves_server_port" "$caves_master_server_port" "$caves_authentication_port" false "$path_to_file"
    fi
}

# server create core function

create_server() {
    if [ -d "./Cluster_$cluster_id/" ]; then
        echo -e "Error : this cluster (Cluster_$cluster_id ) already exists... Aborting"
        exit
    fi
    create_directory "Cluster_$cluster_id"
    cd Cluster_$cluster_id/
    fill_server_ini_wraper "Master"
    if [ "$caves_enabled" = "true" ]; then
        fill_server_ini_wraper "Caves"
        path_to_file="./Caves/worldgenoverride.lua"
        fill_worldgen_lua "$path_to_file"
    fi
    path_to_file="./cluster.ini"
    fill_cluster_ini "$gamemode" "$max_players" "$pvp" "$pause_when_empty" "$cluster_name" "$intention" "$console" "$shard" "$master_port" "$path_to_file" "$password"
    password=" "
}
####MAIN####
current_directory=$(pwd)
cfg_parser "./../config.ini" "path_to_working_directory"
cd $working_directory

case $1 in
    -cmd)
        cd $current_directory
        init_defaults
        cd $working_directory
        read_args "$@"    
        ;;
    "")
        prompt_all
        ;;
    *)
        echo "Error : wrong option b"
        echo
        exit
esac
check_global
create_server

