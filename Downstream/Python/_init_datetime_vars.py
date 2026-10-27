today=datetime.today()
today_m_1week = today - timedelta(days=7)

year_now=today.year
month_now=today.month
day_now=today.day
time_now=today.time()

def Ndays_year(year):
    return 366 if calendar.isleap(year) else 365
def Ndays_month(year, month):
    return calendar.monthrange(year, month)[1]

Ndays_year_now = Ndays_year(year_now)
Ndays_month_now = Ndays_month(year_now, month_now)
