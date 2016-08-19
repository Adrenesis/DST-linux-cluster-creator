create_directory() {
    path_to_directory="./$1/"
    if [ -d "$path_to_direcory" ]; then
        echo "$1 directory already exists"
    else
        mkdir -v $1
    fi
}

ask_port() {
    local var_check=false
    while [ $var_check = false ]
    do
        read -p "Enter port for $1: " -n 6 -r
        port=$REPLY
        var_check=true
        [[ "$port" =~ ^[0-9]+$ ]] || var_check=false
        (( port >= 0 && port <= 65535 )) || var_check=false
        if [ $var_check = false ]; then
            echo
            echo -e "Error : wrong value"
        fi
    done
}


ask_ports() {
    echo "You will be asked for ports:"
    ask_port "master port (in cluster.ini)"
    master_port=$port
    ask_port "server port (in Master/server.ini)"
    master_server_port=$port
    ask_port "master server port (in Master/server.ini)"
    master_master_server_port=$port
    ask_port "authentication port (in Master/server.ini)"
    master_authentication_port=$port
    if [ $caves_disabled = false ]; then
        ask_port "server port (in Caves/server.ini)"
        caves_server_port=$port
        ask_port "master server port (in Caves/server.ini)"
        caves_master_server_port=$port
        ask_port "authentication port (in Master/server.ini)"
        caves_authentication_port=$port
    fi
}


prompt_cluster_creation() {
    read -p "Do you wish to create a new cluster?[y/N]" -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    echo
}
prompt_disable_caves() {
    read -p "Do you wish to enable caves?[Y/n]" -n 1 -r
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        caves_disabled=true
        shard=false
        echo
    else
        caves_disabled=false
        shard=true
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

prompt_cluster_name() {
    read -p "Give your server a name (name of your cluster on steam server browser) : " -r
    cluster_name=${REPLY//[^a-zA-Z0-9_]/}
    echo -e "Your server will be displayed as $cluster_name"
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

prompt_cluster_id() {
    read -p "Give your cluster an ID (folder name of you cluster) : " -r
    cluster_id=${REPLY//[^a-zA-Z0-9_]/}
    echo -e "Your server folder will be Cluster_$cluster_id"
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
    echo " => $1Caves/serve.ini"
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

worldgen_lua() {
    echo -e "return {" >> "$1"
    echo -e "       override_enabled = true," >> "$1"
    echo -e "       preset = \"DST_CAVE\"," >> "$1"
    echo -e "}" >> "$1"

}

cluster_ini() {
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
    echo -e "cluster_intention = $6" >> "${10}"
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

serv_ini() {
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

set_serv_ini() {
    create_directory "$1"
    path_to_file="./$1/server.ini"
    if [ $1 = "Master" ]; then
        serv_ini "$master_server_port" "$master_master_server_port" "$master_authentication_port" true "$path_to_file"
    else
        serv_ini "$caves_server_port" "$caves_master_server_port" "$caves_authentication_port" false "$path_to_file"
    fi
}

create_server() {
    working_directory="/home/adrenesis/.klei/DoNotStarveTogether/" # << line you have to edit to be in the right folder
    cd $working_directory 
    prompt_intro_create_server $working_directory
    prompt_cluster_creation
    prompt_cluster_id
    prompt_cluster_name
    prompt_password
    prompt_max_players
    prompt_gamemode
    prompt_intention
    prompt_disable_caves
    prompt_pvp
    prompt_pause_when_empty
    prompt_console
    ask_ports
    create_directory "Cluster_$cluster_id"
    cd Cluster_$cluster_id/
    set_serv_ini "Master"
    if [ $caves_disabled = false ]; then
        set_serv_ini "Caves"
        path_to_file="./Caves/worldgenoverride.lua"
        worldgen_lua "$path_to_file"
    fi
    path_to_file="./cluster.ini"
    cluster_ini "$gamemode" "$max_players" "$pvp" "$pause_when_empty" "$cluster_name" "$intention" "$console" "$shard" "$master_port" "$path_to_file" "$password"
    password=" "
}
####MAIN####
create_server

