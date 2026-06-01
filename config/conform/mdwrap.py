import re
import subprocess
import sys

# mdformat --wrap reflows ::: container fences (VitePress/markdown-it-container)
# into the surrounding prose because mdformat-myst only recognises the MyST
# brace form ":::{name}", not the VitePress "::: name title" form. We hide each
# fence line behind a placeholder, wrap everything else, then restore them.

FENCE_LINE = re.compile(r"^[ \t]*:{3,}.*$", re.M)
PLACEHOLDER = re.compile(r"<!--FENCE(\d+)-->")


def main() -> None:
    text = sys.stdin.read()

    fences: list[str] = []

    def stash(match: re.Match[str]) -> str:
        fences.append(match.group(0))
        return f"<!--FENCE{len(fences) - 1}-->"

    protected = FENCE_LINE.sub(stash, text)

    result = subprocess.run(
        ["mdformat", "--number", "--wrap", "80", "-"],
        input=protected,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        sys.stderr.write(result.stderr)
        sys.exit(result.returncode)

    out = PLACEHOLDER.sub(lambda m: fences[int(m.group(1))], result.stdout)

    # mdformat treats each placeholder as its own block, so it leaves a blank
    # line just inside every container. Collapse it. This relies on the
    # VitePress convention that an opening fence carries an info string
    # ("::: name") while a closing fence is bare colons (":::"); a blank line
    # before a nested opener is left untouched since it cannot be told apart
    # from a wanted blank before a top-level block.
    out = re.sub(r"^([ \t]*:{3,}[ \t]*\S.*)\n\n", r"\1\n", out, flags=re.M)
    out = re.sub(r"\n\n([ \t]*:{3,}[ \t]*)$", r"\n\1", out, flags=re.M)

    sys.stdout.write(out)


if __name__ == "__main__":
    main()
