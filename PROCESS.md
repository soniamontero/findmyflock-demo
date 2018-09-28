# Process

1. Pick a story from Waffle and start it.

    Example:

    > Search for jobs in multiple cities, not just one

2. Create a local branch in your development environment to work on the story.

    Example:
        $ git fetch
        $ git branch multi-city-search origin/master
        $ git checkout multi-city-search

4. Implement your feature and satisfy relevant test(s).

6. Run the entire test suite.

    Make sure your changes don't break anything else. Fix anything broken.

5. Commit branch to GitHub.

    Example:

        $ git add .     # make sure you only add what should be added
                        # add things to .gitignore if needed
        $ git diff      # sanity check changes
        $ git commit -am 'users can find jobs in multiple cities at once'
        $ git push

6. Create a pull request using the template.

    Use `master` as the root branch

    See [PULL_REQUEST_TEMPLATE.md](PULL_REQUEST_TEMPLATE.md)

    Merge master into branch and resolve conflicts as needed before PR review if
    it is not automatically mergeable without conflicts.

7. Ask someone to review your code.

8. Make any necessary changes.

    Address PR review comments. Any ignored comments should be discussed.

9. Repeat 7 and 8 as needed.

10. Request code merge.

    Ask the Developer Lead to merge your branch.
