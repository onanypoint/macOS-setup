import os

import argparse
from subprocess import PIPE, Popen
import subprocess
import datetime

CWD = os.getcwd()

def run_process(cmd, stdin=None):
    try:
        output = subprocess.check_output(cmd.split(), stderr=subprocess.STDOUT, stdin=stdin)
    except subprocess.CalledProcessError as cpe:
        print("Error")
        print(cpe.output.strip().decode())
        exit(1)

    return output.strip().decode()

def main(args):
    stash_name = "cherryb-stash-{}".format(datetime.datetime.now().strftime("%Y%m%d-%H%M"))

    cmd_fetch_src = "git fetch origin {branch}:{branch}".format(branch=args.source_branch)
    cmd_stash_save = "git stash push -m {}".format(stash_name)
    cmd_checkout_dst = "git checkout -b {} {}".format(args.destination_branch, args.source_branch)
    cmd_push_dst = "git push -u origin {}".format(args.destination_branch)

    cmd_stash_pop = r"git stash pop stash@{0}"

    should_stash = bool(run_process("git diff"))

    current_branch = run_process("git branch --show-current")
    cmd_checkout_current = "git checkout {}".format(current_branch)

    output = run_process(cmd_fetch_src)
    if output:
        print(output)

    if should_stash:
        output = run_process(cmd_stash_save)

    output = run_process(cmd_checkout_dst)

    for sha in args.commits:
        cmd_cherrypick = "git cherry-pick {}".format(sha)
        output = run_process(cmd_cherrypick)
        if output:
            print(output)

    if args.not_push:
        output = run_process(cmd_push_dst)
        if output:
            print(output)

        output = run_process(cmd_checkout_current)
        if output:
            print(output)

        if should_stash:
            output = run_process(cmd_stash_pop)
            if output:
                print(output)

    else:
        print("! Currently on branch {}".format(args.destination_branch))
        print("! Files present on {} have been stashed under the name '{}'".format(args.source_branch, stash_name))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Create a new branch from a source branch and a set of commits using cherry-picks')
    parser.add_argument('source_branch', help='Name of the source branch')
    parser.add_argument('destination_branch', help='Destination branch')
    parser.add_argument('commits', nargs="+", help='Commits SHAs')
    parser.add_argument('-np', '--not-push', action="store_false", help="Don't push directly the branch and checkout original branch")

    args = parser.parse_args()

    main(args)
