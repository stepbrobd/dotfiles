#!/usr/bin/env nix
#!nix shell nixpkgs#git nixpkgs#python311 --command python

import argparse
import os
import pathlib
import subprocess
import sys
import tomllib

from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass


@dataclass
class GeneralConfiguration:
    home: pathlib.Path  # required: managed repo root
    concurrency: int  # optional: max number of concurrent tasks
    env: dict[str, str]  # optional: environment variables to pass to subprocesses


@dataclass
class PlatformConfiguration:
    name: str  # required: platform name
    origin: bool  # required: pull target
    domain: str  # required: platform domain
    user: str  # optional: platform username


@dataclass
class RepoConfiguration:
    name: str  # required: repository name
    description: str  # optional: repository description
    branch: str  # optional: repository branch
    archived: bool  # optional: repository archived


@dataclass
class Configuration:
    general: GeneralConfiguration
    platform: list[PlatformConfiguration]
    repo: list[RepoConfiguration]


def cfgpath() -> pathlib.Path:
    if "REPO_CONFIG" in os.environ:
        return pathlib.Path(os.environ["REPO_CONFIG"])
    elif "XDG_CONFIG_HOME" in os.environ:
        return pathlib.Path(os.environ["XDG_CONFIG_HOME"]) / "repos" / "config.toml"
    else:
        return pathlib.Path.home() / ".config" / "repos" / "config.toml"


def mkcfg() -> Configuration:
    with open(cfgpath(), "rb") as f:
        c = tomllib.load(f)

    return Configuration(
        general=GeneralConfiguration(
            home=pathlib.Path(c.get("general", None).get("home", None)).expanduser(),
            concurrency=c.get("general", 1).get("concurrency", 1),
            env=c.get("general", None).get("env", None),
        ),
        platform=[
            PlatformConfiguration(
                name=k,
                origin=v.get("origin", None),
                domain=v.get("domain", None),
                user=v.get("user", None),
            )
            for k, v in c["platform"].items()
        ],
        repo=[
            RepoConfiguration(
                name=k,
                description=v.get("description", None),
                branch=v.get("branch", "master"),
                archived=v.get("archived", False),
            )
            for k, v in c["repo"].items()
        ],
    )


@dataclass
class Context:
    env: dict[str, str]  # environment variables to pass to subprocesses
    branch: str  # default branch
    remote: dict[str, list[tuple[str, str]]]  # {fetch/push: [(name, uri)]


def mkctx(cfg: Configuration) -> dict[pathlib.Path, Context]:
    return {
        cfg.general.home / r.name: Context(
            env = {**(os.environ or {}), **(cfg.general.env or {})},
            branch=r.branch,
            remote={
                "fetch": [
                    (
                        p.name,
                        f"git@{p.domain}:{p.user + '/' + r.name if p.user else r.name}",
                    )
                    for p in cfg.platform
                    if p.origin
                ],
                "push": [
                    (
                        p.name,
                        f"git@{p.domain}:{p.user + '/' + r.name if p.user else r.name}",
                    )
                    for p in cfg.platform
                ],
            },
        )
        for r in cfg.repo
    }


def exec(
    tgt: list[pathlib.Path],
    ctx: dict[pathlib.Path, Context],
    cfg: Configuration,
) -> None:
    """
    1. collect the last argument (must the the last argument, users must pass the command as a single string)
    2. exec
    """

    def once(tgt: pathlib.Path) -> None:
        print(f"StepBroBD :: Repo :: Exec :: {tgt.as_posix()}:")
        cmd = sys.argv[-1]
        print(f"$ {cmd}")
        subprocess.Popen(cmd.split(), cwd=tgt, env=ctx[tgt].env).communicate()

    with ThreadPoolExecutor(max_workers=cfg.general.concurrency) as executor:
        executor.map(once, tgt)


def init(
    tgt: list[pathlib.Path],
    ctx: dict[pathlib.Path, Context],
    cfg: Configuration,
) -> None:
    """
    1. check .git, if not found, git init, if found, remove all remotes
    2. add remotes, if origin is set, change the platform name to origin
    3. fetch remote
    4. hard reset and checkout
    5. set upstream
    """

    def once(tgt: pathlib.Path) -> None:
        print(f"StepBroBD :: Repo :: Init :: {tgt.as_posix()}:")

        # 1.
        if not (tgt / ".git").exists():
            # mkdir -p {tgt}
            tgt.mkdir(parents=True, exist_ok=True)

            # git init --initial-branch={branch}
            subprocess.run(
                ["git", "init", f"--initial-branch={ctx[tgt].branch}"],
                cwd=tgt,
                env=ctx[tgt].env,
            )
        else:
            # git remote | xargs -L1 git remote remove
            git_remote = subprocess.Popen(
                ["git", "remote"],
                cwd=tgt,
                env=ctx[tgt].env,
                stdout=subprocess.PIPE,
            )
            subprocess.run(
                ["xargs", "-L1", "git", "remote", "remove"],
                cwd=tgt,
                env=ctx[tgt].env,
                stdin=git_remote.stdout,
            )

        # 2.
        for name, uri in ctx[tgt].remote["fetch"]:
            # git remote add origin {uri}
            subprocess.run(
                ["git", "remote", "add", "origin", uri],
                cwd=tgt,
                env=ctx[tgt].env,
            )
        for name, uri in ctx[tgt].remote["push"]:
            # git remote add {name} {uri}
            subprocess.run(
                ["git", "remote", "add", name, uri],
                cwd=tgt,
                env=ctx[tgt].env,
            )

        # 3.
        # git fetch --all
        subprocess.run(
            ["git", "fetch", "--all"],
            cwd=tgt,
            env=ctx[tgt].env,
        )
        # git submodule update --recursive --init
        subprocess.run(
            ["git", "submodule", "update", "--recursive", "--init"],
            cwd=tgt,
            env=ctx[tgt].env,
        )

        # 4.
        # git reset --hard origin/{branch}
        subprocess.run(
            ["git", "reset", "--hard", f"origin/{ctx[tgt].branch}"],
            cwd=tgt,
            env=ctx[tgt].env,
        )
        # git checkout {branch}
        subprocess.run(
            ["git", "checkout", ctx[tgt].branch],
            cwd=tgt,
            env=ctx[tgt].env,
        )

        # 5.
        # git branch --set-upstream-to=origin/{branch} {branch}
        subprocess.run(
            ["git", "branch", f"--set-upstream-to=origin/{ctx[tgt].branch}", ctx[tgt].branch],
            cwd=tgt,
            env=ctx[tgt].env,
        )

    with ThreadPoolExecutor(max_workers=cfg.general.concurrency) as executor:
        executor.map(once, tgt)


def pull(
    tgt: list[pathlib.Path],
    ctx: dict[pathlib.Path, Context],
    cfg: Configuration,
) -> None:
    """
    1. check .git, if not found, print error, if found, continue
    2. pull origin
    """

    def once(tgt: pathlib.Path) -> None:
        print(f"StepBroBD :: Repo :: Pull :: {tgt.as_posix()}:")

        # 1.
        if not (tgt / ".git").exists():
            raise SystemExit(f"fatal: {tgt} was not found")

        # 2.
        # git pull origin {branch}
        subprocess.run(
            ["git", "pull", "origin", ctx[tgt].branch],
            cwd=tgt,
            env=ctx[tgt].env,
        )
        # git submodule update --recursive --remote
        subprocess.run(
            ["git", "submodule", "update", "--recursive", "--remote"],
            cwd=tgt,
            env=ctx[tgt].env,
        )

    with ThreadPoolExecutor(max_workers=cfg.general.concurrency) as executor:
        executor.map(once, tgt)


def push(
    tgt: list[pathlib.Path],
    ctx: dict[pathlib.Path, Context],
    cfg: Configuration,
) -> None:
    """
    1. check .git, if not found, print error, if found, continue
    2. push to all push remotes
    """

    def once(tgt: pathlib.Path) -> None:
        print(f"StepBroBD :: Repo :: Push :: {tgt.as_posix()}:")

        # 1.
        if not (tgt / ".git").exists():
            raise SystemExit(f"fatal: {tgt} was not found")

        # 2.
        for name, _ in ctx[tgt].remote["push"] + [("origin", None)]:
            # git push {name} {branch}
            subprocess.run(
                ["git", "push", name, ctx[tgt].branch],
                cwd=tgt,
                env=ctx[tgt].env,
            )

    with ThreadPoolExecutor(max_workers=cfg.general.concurrency) as executor:
        executor.map(once, tgt)


def main() -> None:
    parser = argparse.ArgumentParser(
        prog="repos",
        description="StepBroBD repository manager",
        add_help=False,
    )
    parser.add_argument(
        "-h",
        "--help",
        action="help",
        help="show this help message and exit",
    )
    parser.add_argument(
        "-v",
        "--version",
        action="version",
        version="%(prog)s {}".format(
            subprocess.check_output(
                [
                    "git",
                    "-C",
                    str(pathlib.Path.home() / "Workspace" / "dotfiles"),
                    "rev-parse",
                    "--short",
                    "HEAD",
                ]
            )
            .decode("utf-8")
            .strip()
        ),
    )

    subparsers = parser.add_subparsers(dest="command")
    commands = ["exec", "init", "pull", "push"]
    locals().update({f"subparser_{c}": subparsers.add_parser(c) for c in commands})
    for c in commands:
        p = locals()[f"subparser_{c}"]
        g = p.add_mutually_exclusive_group()
        g.add_argument(
            "-n",
            "--name",
            type=str,
            help="specify repository to perform action on",
        )
        g.add_argument(
            "-a",
            "--all",
            action="store_true",
            help="perform action on all repositories",
        )

    args, _ = parser.parse_known_args(args=None if sys.argv[1:] else ["--help"])
    cwd = pathlib.Path.cwd()
    cfg = mkcfg()
    ctx = mkctx(cfg)
    tgt = []
    if args.name:
        tgt = [cfg.general.home / args.name]
    elif args.all:
        tgt = [cfg.general.home / r.name for r in cfg.repo if not r.archived]
    else:
        for dir in ctx.keys():
            if cwd.is_relative_to(dir):
                tgt = [dir]
                break
    if not tgt:
        raise SystemExit("fatal: not a managed repository")

    if callable(globals()[args.command]):
        globals()[args.command](tgt, ctx, cfg)


if __name__ == "__main__":
    raise SystemExit(main())
