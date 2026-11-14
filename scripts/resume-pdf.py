# /// script
# requires-python = ">=3.10"
# dependencies = ["weasyprint>=62"]
# ///
"""Render the built Resume page to PDF with WeasyPrint. Run via: uv run scripts/resume-pdf.py URL OUT"""
import sys

from weasyprint import HTML

url, out = sys.argv[1], sys.argv[2]
HTML(url=url).write_pdf(out)
