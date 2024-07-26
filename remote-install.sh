#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.3.4-alpha
# date: 2024-07-26 16:06:50
function command_exists__0_v0 {
    local command=$1
    __AMBER_VAL_0=$(command -v ${command} > /dev/null 2>&1);
    __AS=$?;
if [ $__AS != 0 ]; then
        __AF_command_exists0_v0=0;
        return 0
fi;
    local res="${__AMBER_VAL_0}"
    __AF_command_exists0_v0=1;
    return 0
}
function necesary_commands__2_v0 {
    local is_remote=$1
    __AMBER_ARRAY_0=("docker" "sudo" "rm" "apt");
    local commands=("${__AMBER_ARRAY_0[@]}")
    if [ ${is_remote} != 0 ]; then
        __AMBER_ARRAY_1=("curl");
        commands+=("${__AMBER_ARRAY_1[@]}")
fi
    for command in "${commands[@]}"
do
        command_exists__0_v0 "${command}";
        __AF_command_exists0_v0__11_12=$__AF_command_exists0_v0;
        if [ $(echo $__AF_command_exists0_v0__11_12 '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
            echo "Command ${command} wasn't found. Please install it."
            __AF_necesary_commands2_v0='';
            return 1
fi
done
}
function command_exists__4_v0 {
    local command=$1
    __AMBER_VAL_1=$(command -v ${command} > /dev/null 2>&1);
    __AS=$?;
if [ $__AS != 0 ]; then
        __AF_command_exists4_v0=0;
        return 0
fi;
    local res="${__AMBER_VAL_1}"
    __AF_command_exists4_v0=1;
    return 0
}
function matches__6_v0 {
    local text=$1
    local regex=$2
    command_exists__4_v0 "grep";
    __AF_command_exists4_v0__4_8=$__AF_command_exists4_v0;
    if [ $(echo $__AF_command_exists4_v0__4_8 '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        echo "Grep command wasn't found"
        __AF_matches6_v0='';
        return 1
fi
    echo "${text}" | grep -E "${regex}" > /dev/null 2>&1;
    __AS=$?;
if [ $__AS != 0 ]; then
        __AF_matches6_v0=0;
        return 0
fi
    __AF_matches6_v0=1;
    return 0
}
function is_version_correct__8_v0 {
    local version=$1
    matches__6_v0 "${version}" "^v\d+\.\d+\.\d+$";
    __AS=$?;
if [ $__AS != 0 ]; then
__AF_is_version_correct8_v0=''
return $__AS
fi;
    __AF_matches6_v0__4_12=$__AF_matches6_v0;
    __AF_is_version_correct8_v0=$__AF_matches6_v0__4_12;
    return 0
}
args=("$@")
    necesary_commands__2_v0 1;
    __AS=$?;
if [ $__AS != 0 ]; then

exit $__AS
fi;
    __AF_necesary_commands2_v0__5_5=$__AF_necesary_commands2_v0;
    echo $__AF_necesary_commands2_v0__5_5 > /dev/null 2>&1
    neovim_version=$(if [ $([ "_${args[1]}" == "_" ]; echo $?) != 0 ]; then echo "${args[1]}"; else echo "latest"; fi)
    is_version_correct__8_v0 "${neovim_version}";
    __AS=$?;
if [ $__AS != 0 ]; then

exit $__AS
fi;
    __AF_is_version_correct8_v0__9_39=$__AF_is_version_correct8_v0;
    if [ $(echo $([ "_${neovim_version}" == "_latest" ]; echo $?) '&&' $(echo $__AF_is_version_correct8_v0__9_39 '==' 0 | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//') != 0 ]; then
        echo "Version ${neovim_version} invalid."
fi
    __AMBER_VAL_2=$(curl -s "https://raw.githubusercontent.com/arch-fan/neovim-raspberry/main/Dockerfile");
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "Error at fetching Dockerfile."
        exit 1
fi;
    dockerfile="${__AMBER_VAL_2}"
    echo "${dockerfile}" | docker build --build-arg NEOVIM_VERSION="${neovim_version}" -t neovim-build -;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "Error at building Docker container."
        exit 1
fi
    docker run -d --name neovim-build neovim-build;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "Failed at running Docker container."
        exit 1
fi
    docker cp neovim-build:/neovim/build/nvim-linux64.deb ./nvim-linux64.deb;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "Failed at copying deb file from container."
fi
    sudo apt install -y ./nvim-linux64.deb;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "Error at installing deb file with apt."
fi
    rm ./nvim-linux64.deb;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "Error at removing deb file from current directory."
fi
    docker rm -f neovim-build;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "Error ar removing Docker container."
fi
    docker rmi neovim-build;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "Error at removing Docker image."
fi
    echo "Installation finished!"