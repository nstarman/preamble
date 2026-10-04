# /// script
# requires-python = ">=3.11"
# dependencies = ["resvg-py"]
# ///
"""Draw the preamble logo: a document, its preamble shaded.

A page with a folded corner. Its top band, the preamble, is shaded and crossed
by a big backslash, LaTeX's command character; the body below is a few grey
lines of text. The shapes are vector, so the logo is written as an SVG, sharp at
any size; for a bitmap, name a .png and give its size::

    uv run docs/_static/make_logo.py                     # favicon.svg
    uv run docs/_static/make_logo.py --size 2048 big.png
"""

import argparse
from pathlib import Path

NAVY, PURPLE, GREY = "#030a23", "#7738eb", "#c9d1d9"

# In a 64-unit square. The page: left, top, right and bottom, and its folded
# corner's size. The preamble band's height. The backslash's two ends. The body's
# lines: where they start, and each one's y and right end.
PAGE = (12, 6, 52, 58, 10)
PREAMBLE = 19
BACKSLASH = ((18, 10), (30, 32))
LINE_START = 18
LINES = ((38, 46), (44, 46), (50, 36))

SVG = """\
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" width="512" height="512">
  <path d="{page}" fill="#fff" stroke="{navy}" stroke-width="3" stroke-linejoin="round"/>
  <rect x="{bx:g}" y="{by:g}" width="{bw:g}" height="{bh:g}" fill="{purple}"
    opacity="0.18"/>
  <g fill="none" stroke-linecap="round" stroke-linejoin="round">
    <path d="{fold}" stroke="{navy}" stroke-width="3"/>
    <path d="{backslash}" stroke="{purple}" stroke-width="5"/>
    <path d="{lines}" stroke="{grey}" stroke-width="2.6"/>
  </g>
</svg>
"""


def svg() -> str:
    """Return the logo as SVG text."""
    left, top, right, bottom, fold = PAGE
    page = f"M{left:g} {top:g}H{right - fold:g}L{right:g} {top + fold:g}"
    page += f"V{bottom:g}H{left:g}Z"
    crease = f"M{right - fold:g} {top:g}V{top + fold:g}H{right:g}"
    (x0, y0), (x1, y1) = BACKSLASH
    # The band sits inside the page's 3-unit outline, and stops at the fold.
    inset = 1.5
    return SVG.format(
        page=page,
        fold=crease,
        backslash=f"M{x0:g} {y0:g}L{x1:g} {y1:g}",
        lines="".join(f"M{LINE_START:g} {y:g}H{end:g}" for y, end in LINES),
        bx=left + inset,
        by=top + inset,
        bw=right - fold - left - inset,
        bh=PREAMBLE,
        navy=NAVY,
        purple=PURPLE,
        grey=GREY,
    )


def main() -> None:
    """Parse the command line and save the logo."""
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument(
        "out",
        nargs="?",
        type=Path,
        default=Path(__file__).with_name("favicon.svg"),
        help="output file, SVG or PNG by its extension (default: favicon.svg)",
    )
    parser.add_argument(
        "--size", type=int, default=512, help="pixels per side, for a PNG"
    )
    args = parser.parse_args()

    if args.out.suffix == ".svg":
        args.out.write_text(svg())
    else:
        import resvg_py  # noqa: PLC0415  # only a PNG needs a renderer

        png = resvg_py.svg_to_bytes(svg_string=svg(), width=args.size)
        args.out.write_bytes(bytes(png))


if __name__ == "__main__":
    main()
