export PATH="/opt/homebrew/bin:$PATH"

# Load version control information
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '(%b)'

# Initialize color support
autoload -U colors && colors
setopt PROMPT_SUBST

# Function to get the current Kubernetes namespace
current_namespace() {
  local ns=$(kubectl config view --minify --output 'jsonpath={..namespace}')
  echo ${ns:-default}
}

# Function to get the admin user's full name from system settings
admin_full_name() {
  # Use the "id -un" command to get the current logged-in user's username
  # and then fetch the full name of this user from the system.
  local user_name=$(id -un)
  # Updated the cut command to start from character 11 to remove 'RealName: ' prefix
  local full_name=$(dscl . -read /Users/$user_name RealName | tail -1 | cut -c 11-)
  echo $full_name
}


# Define the prompt including the admin user's name, current Kubernetes context/namespace, and git branch
PROMPT='%B%F{cyan}$(admin_full_name) %B%F{green}$(kubectl config current-context)/$(current_namespace)%b%f %B%F{blue}$vcs_info_msg_0_%b%f %F{white}%*%f %# '

# Ensure the prompt includes the current git branch information
RPROMPT='$(vcs_info)'

# This is necessary to update the vcs_info (git branch) dynamically in the prompt
precmd() {
  vcs_info
}