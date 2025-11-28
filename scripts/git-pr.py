# /// script
# dependencies = [ "rich", "click" ]
# ///

# TODO use the python distibution of the Azure CLI as the base?


# C:\Program Files\Microsoft SDKs\Azure\CLI2\

import json
import webbrowser
from subprocess import check_call, check_output, run

import click

# TODO use GitPython and Azure API directly for better speed
# TODO should we rebase onto master (or the target branch) and push first?
# TODO make a better cli to allow git pr [abandon,publish,done] (done == merge on completed)
# TODO can/should we query the build status and even output from the API here... if we can scrape
#      any pytest failures and re-run locally...
# TODO un-abandon if we push it more?


def az(*command):
    return json.loads(
        check_output(
            ["az", *command, "-o", "json"],
            encoding="utf8",
            shell=True,
        )
    )


def create_pr(branch):
    # this will fail if we haven't setup a remote branch yet - git push first
    # and then parse the output?
    source_ref = check_output(
        ["git", "config", "get", f"branch.{branch}.merge"], encoding="utf"
    ).strip()

    # TODO just report the id and repository id?
    results = az(
        "repos",
        "pr",
        "list",
        "--query",
        f"[?sourceRefName == '{source_ref}' && status == 'active']",
    )

    if not results:
        print("Creating a new PR")
        pr = az("repos", "pr", "create", "--delete-source-branch")

    else:
        (pr,) = results
        print(f"Found existing PR {pr['pullRequestId']}")

    # get the repo separately as the webUrl is missing from the pr result
    repo = az("repos", "show", "--repository", pr["repository"]["id"])

    return "/".join(
        [
            repo["webUrl"],
            "pullrequest",
            str(pr["pullRequestId"]),
        ]
    )


if __name__ == "__main__":
    branch = check_output(["git", "branch", "--show-current"], encoding="utf8").strip()
    config_key = f"branch.{branch}.pull-request-url"

    url = run(
        ["git", "config", "get", config_key], capture_output=True, encoding="utf8"
    ).stdout.strip()

    # TODO this shoudln't be cached as it resurrects old PRs

    if not url:
        url = create_pr(branch)

    check_call(["git", "config", "set", config_key, url], encoding="utf8")

    webbrowser.open(url)
