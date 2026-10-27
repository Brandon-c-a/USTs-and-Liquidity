FRB_RPresults_PATH = Path(f"{FRBNYdir}"'/rp/results')
FRB_RPresults_files = list(FRB_RPresults_PATH.glob("MASTER.parquet"))

FRB_sclend_PATH = Path(f"{FRBNYdir}"'/seclending/results')
FRB_sclend_files = list(FRB_sclend_PATH.glob("MASTER.parquet"))

FRB_tsy_PATH = Path(f"{FRBNYdir}"'/tsy/results')
FRB_tsy_files = list(FRB_tsy_PATH.glob("MASTER.parquet"))

FRB_ambs_PATH = Path(f"{FRBNYdir}"'/ambs/results')
FRB_ambs_files = list(FRB_ambs_PATH.glob("MASTER.parquet"))

FRB_fxs_PATH = Path(f"{FRBNYdir}"'/fxs')
FRB_fxs_files = list(FRB_fxs_PATH.glob("MASTER.parquet"))

FRB_rates_PATH = Path(f"{FRBNYdir}"'/rates')
FRB_rates_files = list(FRB_rates_PATH.glob("MASTER.parquet"))

FRB_soma_tsy_PATH = Path(f"{FRBNYdir}"'/soma/tsy')
FRB_soma_tsy_files = list(FRB_soma_tsy_PATH.glob("MASTER.parquet"))

# agency currently hashed out in _init_polars_dfs.py
FRB_soma_agency_PATH = Path(f"{FRBNYdir}"'/soma/agency')
FRB_soma_agency_files = list(FRB_soma_agency_PATH.glob("MASTER.parquet"))
