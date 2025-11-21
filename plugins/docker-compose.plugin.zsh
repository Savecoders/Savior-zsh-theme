function is_dock_project() {
    [[ -f docker-compose.yml || -f docker-compose.yaml ]]
}


function dock_status() {
    # not find docker-compose
    if ! is_dock_project; then
        return
    fi

    local service state
    
    echo -n ""
    
    docker compose ps -a --format '{{.Service}}:{{.State}}' | while read line
    do
        [[ -z "$line" ]] && continue

        service="${line%%:*}"
        state="${line##*:}"
        if [[ "$state" == *"running"* ]]; then
            echo -n "%B%F{green}${service}%f%b "
        else
            echo -n "%B%F{red}${service}%f%b "
        fi
    done
    
    echo -n ""
}
