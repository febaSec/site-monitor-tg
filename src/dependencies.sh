function dependencies(){
	local REQUIRED_CMDS=("curl" "jq")
	local missing_cmds=()

	for cmd in "${REQUIRED_CMDS[@]}"; do
	if ! command -v "$cmd" &> /dev/null; then
		 missing_cmds+=("$cmd")
	fi
	done

	if [[ ${#missing_cmds[@]} -ne 0 ]]; then
		echo -e "${RED}[!] Error: The following dependencies are missing:${NC}"
		for m in "${missing_cmds[@]}"; do
			echo "  - $m"
		done
    		echo -e "${YELLOW}Please install the required packages and try again.${NC}"
    		exit 1
	fi
}
