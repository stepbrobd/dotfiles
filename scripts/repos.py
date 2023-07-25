#!/usr/bin/env python3

import argparse
from concurrent.futures import ThreadPoolExecutor
import os
import pathlib
import subprocess
import sys
import tomllib
from typing import Callable


def get_config() -> dict:
    with open(
        pathlib.Path(os.environ["XDG_CONFIG_HOME"])
        if "XDG_CONFIG_HOME" in os.environ
        else pathlib.Path.home()/".config"
        /"repos"/"config.toml", "rb"
        ) as f:
        return tomllib.load(f)


def check(func: Callable[..., None]) -> Callable[..., None]:
    def wrapper(*args, **kwargs):
        cwd = pathlib.Path.cwd()
        root = pathlib.Path(args[0]["general"]["home"]).expanduser()
        repos = args[0]["repo"].keys()

        if kwargs["all"]:
            pass
        else:
            if not pathlib.Path(cwd/".git").exists():
                raise SystemExit(
                    "Current working directory is not a git repository"
                )

            if not cwd.as_posix().startswith(root.as_posix()):
                raise SystemExit(
                    "Current working directory is not in managed repo root"
                )

            if cwd.as_posix().replace(root.as_posix(), "")[1:] not in repos:
                raise SystemExit(
                    "Current working directory is not in managed repo list"
                )

        return func(*args, **kwargs)

    return wrapper


def init(
        config: dict,
        name: str = None,
        all: bool = False,
        *args,
        **kwargs, 
) -> None:
    origin = []
    remotes = {}
    for key, value in config["platform"].items():
        remotes[key] = value["private"]
        if value["origin"]:
            origin.append(key)

    if len(origin) != 1:
        raise SystemExit("There must be exactly one origin platform")
    origin = origin[0]

    def init_once(name: str) -> None:
        directory = pathlib.Path(config["general"]["home"]).expanduser()/name
        print(f"Initializing {directory}")
        if not directory.exists():
            directory.mkdir(parents=True)
        subprocess.run(
            ["git", "init"],
            cwd=directory
        )
        subprocess.run(
            ["git", "remote", "add", "origin", f"{remotes[origin]}/{name}"],
            cwd=directory
        )
        subprocess.run(
            ["git", "fetch", "--all"],
            cwd=directory
        )
        branch = subprocess.check_output(
            ["git", "ls-remote", "--symref", "origin", "HEAD"],
            cwd=directory
        ).decode("utf-8").strip().split("\t")[0].split("/")[-1]
        subprocess.run(
            ["git", "reset", "--hard", f"origin/{branch}"],
            cwd=directory
        )
        subprocess.run(
            ["git", "branch", "-u", f"origin/{branch}", branch],
            cwd=directory
        )
        for key, value in remotes.items():
            subprocess.run(
                ["git", "remote", "add", key, f"{value}/{name}"],
                cwd=directory
            )

    if name:
        task = [name]
    elif all:
        task = config["repo"].keys()
    else:
        task = [ pathlib.Path.cwd().name ]

    with ThreadPoolExecutor(max_workers=1) as executor:
         executor.map(init_once, task)


@check
def pull(
        config: dict,
        all: bool = False,
        force: bool = False,
        *args,
        **kwargs,
) -> None:
    def pull_once(directory: pathlib.Path) -> None:
        print(f"Pulling {directory}")
        branch = subprocess.check_output(
            ["git", "symbolic-ref", "--short", "HEAD"],
            cwd=directory
        ).decode("utf-8").strip()
        if force:
            subprocess.run(
                ["git", "fetch", "--all"],
                cwd=directory
            )
            subprocess.run(
                ["git", "reset", "--hard", f"origin/{branch}"],
                cwd=directory
            )
        else:
            subprocess.run(
                ["git", "pull", "origin", branch],
                cwd=directory
            )

    if all:
        task = [ 
            pathlib.Path(config["general"]["home"]).expanduser()/name
            for name in config["repo"].keys() 
        ]
    else:
        task = [ pathlib.Path.cwd() ]

    with ThreadPoolExecutor(max_workers=1) as executor:
       executor.map(pull_once, task)


@check
def push(
        config: dict,
        all: bool = False,
        force: bool = False,
        *args,
        **kwargs,
) -> None:
    remotes = config["platform"].keys()

    def push_once(directory: pathlib.Path) -> None:
        print(f"Pushing {directory}")
        branch = subprocess.check_output(
            ["git", "symbolic-ref", "--short", "HEAD"],
            cwd=directory
        ).decode("utf-8").strip()
        if force:
            for remote in remotes:
                subprocess.run(
                    ["git", "push", "--force", remote, branch],
                    cwd=directory
                )
        else:
            for remote in remotes:
                subprocess.run(
                    ["git", "push", remote, branch],
                    cwd=directory
                )

    if all:
        task = [ 
            pathlib.Path(config["general"]["home"]).expanduser()/name
            for name in config["repo"].keys() 
        ]
    else:
        task = [ pathlib.Path.cwd() ]

    with ThreadPoolExecutor(max_workers=1) as executor:
       executor.map(push_once, task)


def main() -> None:
    parser = argparse.ArgumentParser(
        prog="repos",
        description="StepBroBD repository manager",
        add_help=False,
    )
    parser.add_argument("-h", "--help",
                        action="help", 
                        help="Show this help message and exit"
                    )
    parser.add_argument("-v", "--version",
                        action="version", 
                        version="%(prog)s {}".format(
                            subprocess.check_output(["git",
                                 "-C", str(pathlib.Path.home()/".config"/"dotfiles"),
                                 "rev-parse", "--short", "HEAD"]
                        )
        .decode("utf-8")
        .strip()
    ))

    subparsers = parser.add_subparsers(dest="command")

    init_parser = subparsers.add_parser("init")
    init_parser.add_argument("-n", "--name",
                             type=str,
                             help="Repository name"
                             )
    init_parser.add_argument("-a", "--all",
                             action="store_true",
                             help="Init all managed repositories"
                             )

    pull_parser = subparsers.add_parser("pull")
    pull_parser.add_argument("-a", "--all",
                             action="store_true",
                             help="Pull all managed repositories"
                             )
    pull_parser.add_argument("-f", "--force",
                             action="store_true",
                             help="Force action without confirmation"
                             )

    push_parser = subparsers.add_parser("push")
    push_parser.add_argument("-a", "--all",
                             action="store_true",
                             help="Push all managed repositories"
                             )
    push_parser.add_argument("-f", "--force",
                             action="store_true",
                             help="Force action without confirmation"
                             )
    
    args = parser.parse_args(args=None if sys.argv[1:] else ["--help"])

    match args.command:
        case "init":
            init(get_config(), **args.__dict__)
        case "pull":
            pull(get_config(), **args.__dict__)
        case "push":
            push(get_config(), **args.__dict__)


if __name__ == "__main__":
    raise SystemExit(main())
