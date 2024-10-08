"""Helm Charts Site configuration.
Configuration file for the Sphinx documentation builder.

For the full list of built-in configuration values, see the documentation:
https://www.sphinx-doc.org/en/master/usage/configuration.html

-- Project information -----------------------------------------------------
https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information
"""
# pylint: disable=invalid-name,redefined-builtin
from pathlib import Path
import version_query

def get_release():
    """Query the current release for the project."""
    try:
        repo_path = Path('.')
        ret_value = version_query.git_query.query_git_repo(repo_path).to_str()
    except ValueError:
        ret_value = version_query.Version.from_str('0.0.1').devel_increment().to_str()
    return ret_value

def get_html_extra_paths():
    """Get a list of files to be copied to the HTML output directory."""
    ret_value = ['index.yaml', 'charts/index.yaml']
    extra_paths = Path('.').glob('*.tgz')
    for extra_path in extra_paths:
        ret_value.append(str(extra_path))
        ret_value.append(f'charts/{str(extra_path)}')
    return ret_value

author = 'Xander Harris'
autoyaml_root = "."
autoyaml_doc_delimiter = "###"
autoyaml_comment = "#"
autoyaml_level = 10
autoyaml_safe_loader = True
copyright = '2024, Xander Harris'


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
    'charts/storage-classes/*',
    'charts/nautobot/*',
    'charts/postgresql/*',
    'charts/redis/*',
    'charts/calico/*',
]
extensions = [
    'myst_parser',
    'sphinx.ext.autodoc',
    'sphinx.ext.githubpages',
    'sphinxcontrib.autoyaml',
]

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output
html_extra_path = get_html_extra_paths()
html_favicon = '_static/img/logo/helm.png'
html_logo = '_static/img/logo/helm.png'
html_static_path = ['_static']
html_theme = 'sphinx_book_theme'
myst_dmath_double_inline = True
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
release = get_release()
project = 'Charts'
source_suffix = {
    '.md': 'markdown',
    '.rst': 'restructuredText',
}
templates_path = ['_templates']
