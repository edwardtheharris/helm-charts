"""Helm Charts Site configuration.
# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information
"""
# pylint: disable=invalid-name,redefined-builtin
from pathlib import Path

def get_html_extra_paths():
    """Get a list of files to be copied to the HTML output directory."""
    ret_value = ['index.yaml', 'charts/index.yaml']
    extra_paths = Path('.').glob('*.tgz')
    for extra_path in extra_paths:
        ret_value.append(str(extra_path))
        ret_value.append(f'charts/{str(extra_path)}')
    return ret_value

author = 'Xander Harris'
copyright = '2024, Xander Harris'
# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

exclude_patterns = [
    '_build',
    '.DS_Store',
    '.gnupg',
    '.venv',
    'Thumbs.db',
    'charts/storage_classes/*'
]
extensions = [
    'myst_parser',
    'sphinx.ext.githubpages',
]

html_extra_path = get_html_extra_paths()
html_static_path = ['_static']
html_theme = 'alabaster'
myst_dmath_double_inline=True
myst_enable_extensions = [
    "amsmath",
    "attrs_block",
    "attrs_inline",
    "colon_fence",
    "deflist",
    "dollarmath",
    "fieldlist",
    "html_admonition",
    "html_image",
    "linkify",
    "replacements",
    "smartquotes",
    "strikethrough",
    "substitution",
    "tasklist",
]
myst_title_to_header = True
release = '0.0.1'
project = 'Charts'
templates_path = ['_templates']


# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output
