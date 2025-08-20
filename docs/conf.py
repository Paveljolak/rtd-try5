# Configuration file for the Sphinx documentation builder.
project = 'docs'
copyright = '2025, pavel'
author = 'pavel'
release = '1.0'

import os
import sys
sys.path.insert(0, os.path.abspath('.'))
extensions = []
templates_path = ['_templates']
html_baseurl = ''
html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']
html_sidebars = { '**': ['localtoc.html', 'relations.html', 'sourcelink.html', 'searchbox.html', 'versions.html'] }
smv_tag_whitelist = r'^.*$'
smv_branch_whitelist = r'^(main|jazzy|humble|test)$'
smv_outputdir_format = '{ref.name}'
