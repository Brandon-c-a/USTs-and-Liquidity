get_ipython().run_line_magic('run', '-i mdata/.bin/_init_imports.py')
get_ipython().run_line_magic('run', '-i mdata/.bin/_init_datetime_vars.py')

get_ipython().run_line_magic('run', '-i mdata/.bin/_init_PATH_UST.py')
get_ipython().run_line_magic('run', '-i mdata/.bin/_init_polars_UST.py')
get_ipython().run_line_magic('run', '-i mdata/.bin/_init_polars_BLS.py')
get_ipython().run_line_magic('run', '-i mdata/.bin/_init_helpers_UST.py')


get_ipython().run_line_magic('run', '-i mdata/.bin/L1customization_UST.py')
get_ipython().run_line_magic('run', '-i mdata/.bin/TIPS_CPI.py')
get_ipython().run_line_magic('run', '-i mdata/.bin/UST_FRN.py')
#%run -i mdata/.bin/__init__polars_fresh_dfs.py


# In[33]:


get_ipython().run_line_magic('run', '-i mdata/.bin/_init_PATH_FRBNY.py')
get_ipython().run_line_magic('run', '-i mdata/.bin/_init_polars_FRBNY.py')
get_ipython().run_line_magic('run', '-i mdata/.bin/_init_helpers_FRBNY.py')
