import os
import json
import argparse
import subprocess
import shutil
import sys
import diff

# 读取配置文件
def read_config(config_file):
    with open(config_file, 'r') as f:
        return json.load(f)

# 获取变量的值：首先从配置文件中获取，若不存在则从环境变量获取，若仍不存在则报错
def get_variable(config, key, env_key):
    value = config.get(key, os.environ.get(env_key))
    if value is None:
        print(f"Error: {key} not found in the config file or environment variable '{env_key}'")
        sys.exit(1)
    return value

# 执行git命令
def run_git_command(repo_path, command):
    full_command = ['git', '-C', repo_path] + command
    subprocess.run(full_command, check=True)


def get_actual_repo_name(config, repo_identifier):
    if repo_identifier in config['repositories']:
        return repo_identifier
    for actual_name, repo_info in config['repositories'].items():
        if repo_info.get('alias') == repo_identifier:
            return actual_name
    return None

def manage_repo(config, repo_identifier, action, group=False):
    actual_repo_name = get_actual_repo_name(config, repo_identifier)
    if actual_repo_name is None:
        print(f"Error: {repo_identifier} not found in the repositories list or alias.")
        return

    repo_info = config['repositories'][actual_repo_name]
    repo_path = os.path.join('.', actual_repo_name)
    if action == 'clone':
        if not os.path.exists(repo_path):
            print(f"Cloning {actual_repo_name}...")
            # 使用 default_branch 字段
            if actual_repo_name == "ps-app-cae-prepost":
                print("clone depth  is 1")
                subprocess.run(['git', 'clone', '--depth', '1', '--branch',repo_info['branch'], repo_info['url']], check=True)
            else:
                subprocess.run(['git', 'clone', '-b', repo_info['branch'], repo_info['url']], check=True)
        else:
            print(f"{actual_repo_name} already exists, skipping clone.")
    elif action == 'pull':
        if os.path.exists(repo_path):
            print(f"Pulling {actual_repo_name}...")
            if(actual_repo_name == "ps-app-cae-prepost"):
                run_git_command(repo_path, ['reset' ,'--hard','HEAD'])
                run_git_command(repo_path, ['clean','-fd'])
            run_git_command(repo_path, ['pull', '--rebase'])
        else:
            print(f"{actual_repo_name} does not exist, skipping pull.")
    elif action == 'status':
        if os.path.exists(repo_path):
            print(f"Getting status for {actual_repo_name}...")
            run_git_command(repo_path, ['status'])
        else:
            print(f"{actual_repo_name} does not exist, skipping status.")
    elif action == 'checkout':
        if os.path.exists(repo_path):
            print(f"Checking out {actual_repo_name}...")
            if group and actual_repo_name in config['group']:
                run_git_command(repo_path, ['checkout', config['group'][actual_repo_name]])
            else:
                run_git_command(repo_path, ['checkout', config['actions'][action][actual_repo_name]])
        else:
            print(f"{actual_repo_name} does not exist, skipping checkout.")
    else:
        print(f"Error: Unknown action '{action}'.")

# 获取仓库状态
def get_repo_status(config):
    for repo_name in config['actions']['status']:
        repo_path = os.path.join('.', repo_name)
        if os.path.exists(repo_path):
            print(f"Getting status for {repo_name}...")
            run_git_command(repo_path, ['status'])
        else:
            print(f"{repo_name} does not exist, skipping status.")

# 执行CMake构建
def run_cmake_build(config, debug,repo_path):
    cwd = os.getcwd()
    os.chdir(repo_path)
    print("cwd" + os.getcwd())
    # Directories and paths
    HDIR = "./"
    BDIR = "./build/ninja"
    IDIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../ps-app-cae-prepost/install")).replace("\\", "/")
    print(f"Install directory: {IDIR}")

    print(IDIR)

    # 获取配置或环境变量
    QT_DEV_PATH = get_variable(config, 'QT_DEV_PATH', 'QT_DEV_PATH')
    #CMAKE_BIN_PATH = get_variable(config, 'CMAKE_BIN_PATH', 'CMAKE_BIN_PATH')

    # Update path with CMake binary path
    os.environ['PATH'] += os.pathsep #+ CMAKE_BIN_PATH

    # CMake command, including compile_commands.json generation
    cmake_command = [
        "cmake",
        "--no-warn-unused-cli",
        "-DCMAKE_VERBOSE_MAKEFILE:BOOL=FALSE",
        "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",  # Enable generation of compile_commands.json
        "-DCMAKE_SKIP_RPATH:BOOL=FALSE",
        "-DCMAKE_SKIP_INSTALL_RPATH:BOOL=FALSE",
        "-DCMAKE_DEBUG_POSTFIX:STRING=_d",
        "-DCMAKE_MINSIZEREL_POSTFIX:STRING=_minsize",
        "-DCMAKE_RELWITHDEBINFO_POSTFIX:STRING=_debinfo",
        "-DCMAKE_CXX_STANDARD:STRING=17",
        "-DCMAKE_CXX_STANDARD_REQUIRED:BOOL=TRUE",
        "-DCMAKE_CXX_EXTENSIONS:BOOL=FALSE",
        f"-DCMAKE_INSTALL_PREFIX:STRING={IDIR}",
        f"-D CMAKE_PREFIX_PATH={QT_DEV_PATH}",
        f"-S {HDIR}",
        f"-B {BDIR}",
        "-G", "Ninja Multi-Config"
    ]

    # Run CMake
    subprocess.run(cmake_command, check=True)

    # Build and install
    build_type = "Debug" if debug else "Release"
    subprocess.run(["cmake", "--build", BDIR, "--config", build_type, "--target", "install"], check=True)

    # Copy the compile_commands.json to the root directory (where CMakeLists.txt is located)
    compile_commands_src = os.path.join(BDIR, 'compile_commands.json')
    if os.path.exists(compile_commands_src):
        compile_commands_dest = os.path.join(HDIR, 'compile_commands.json')
        shutil.copyfile(compile_commands_src, compile_commands_dest)
        print(f"Copied compile_commands.json to {compile_commands_dest}")
    else:
        print("Error: compile_commands.json not found in the build directory.")
    os.chdir(cwd)

def build_repos(config, build_mode, repos=None):
    if repos is None:
        repos = config['actions']['build']
    for repo_name in repos:
        actual_repo_name = get_actual_repo_name(config, repo_name)
        if actual_repo_name is None:
            print(f"Error: {repo_name} not found in the repositories list or alias.")
            continue
        repo_path = os.path.join('.', actual_repo_name)
        if os.path.exists(repo_path):
            print(f"Building {actual_repo_name} in {build_mode} mode...")
            run_cmake_build(config, build_mode == 'debug', repo_path)
        else:
            print(f"{actual_repo_name} not found, skipping build.")

def check_cmake(config, repo):
                actual_repo_name = get_actual_repo_name(config, repo)
                if actual_repo_name is None:
                    print(f"Error: {repo} not found in the repositories list or alias.")
                    return
                repo_path = os.path.join('.', actual_repo_name)
                curdir = os.getcwd()
                os.chdir(repo_path)
                diff.main()
                os.chdir(curdir)

def main():
    parser = argparse.ArgumentParser(
        description="Manage repositories and build projects.",
        epilog="Use this script to manage git repositories and build your project using CMake."
    )
    
    parser.add_argument('--config', required=False, help='Path to the configuration file (JSON format).')
    parser.add_argument('--repos', nargs='+', help='Specify one or more repositories to perform the git command on.')
    parser.add_argument('--git-command', choices=['clone', 'pull', 'status', 'checkout'], help='Execute a git command on specified repositories.')
    parser.add_argument('--build', choices=['debug', 'release'], help='Build the project in debug or release mode using CMake.')
    parser.add_argument('--diff-CMake', help='Check project\'s CMakeLists.txt whether to update')
    parser.add_argument('--group', required=False, help=' checkout to group branch')

    args = parser.parse_args()
    config = {}
    if(args.config):
        config = read_config(args.config)
    else:
        with open("./config.json", "r") as file:
            config = json.load(file)

    if args.git_command and args.repos:
        for repo in args.repos:
            manage_repo(config, repo, args.git_command, args.group)
    elif args.git_command:
        for repo_name in config['actions'][args.git_command]:
            manage_repo(config, repo_name, args.git_command, args.group)
    
    if args.diff_CMake:
        if args.repos:
            for repo in args.repos:
                check_cmake(config, repo)
        else:
            for repo,value in config['repositories'].items():
                print(repo)
                check_cmake(config, repo)

    if args.build:
        build_repos(config, args.build, args.repos)

if __name__ == '__main__':
    main()



