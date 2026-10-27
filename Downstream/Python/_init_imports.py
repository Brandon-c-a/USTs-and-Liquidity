import os, sys, json, itertools, glob, subprocess, csv, time, datetime, calendar
from dotenv import load_dotenv
load_dotenv()

os.environ["JAX_ENABLE_X64"] = "True"            
#os.environ['XLA_PYTHON_CLIENT_ALLOCATOR'] = 'cuda_async'             
#os.environ["XLA_PYTHON_CLIENT_MEM_FRACTION"] = "0.975"

from pathlib import Path
from datetime import datetime, date, time, timedelta

import pandas as pd
import polars as pl
import polars.selectors as cs
import numpy as np
from functools import partial
from numpy.lib.stride_tricks import sliding_window_view

from fredapi import Fred

import jax
import jax.numpy as jnp
from jax import jit, vmap,  lax, random
from jax.scipy.special import ndtr
from jax.scipy.stats import norm 
from sklearn.linear_model import RidgeCV, Ridge
from sklearn.model_selection import TimeSeriesSplit, GridSearchCV
from sklearn.pipeline import Pipeline, make_pipeline
from sklearn.preprocessing import StandardScaler
from statsmodels.stats.multitest import multipletests
from statsmodels.tsa.stattools import adfuller
#from DuckPolarsMarket import DuckPolarsMarketIO           #db = DuckPolarsMarketIO()                    #import yfinance
import urllib.request
import xml.etree.ElementTree as ET
import re
pl.Config.set_tbl_cols(-1)
pl.Config.set_tbl_width_chars(-1)
