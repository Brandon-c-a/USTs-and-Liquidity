FRB_soma_tsy = FRB_soma_tsy.with_columns(
    pl.col("CUSIP").str.strip_chars("'")
)
