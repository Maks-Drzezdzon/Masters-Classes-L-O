import pandas as pd

df = pd.read_excel('http://archive.ics.uci.edu/ml/machine-learning-databases/00352/Online%20Retail.xlsx')
print(df.head())

country_sales = df.groupby(['Country'])['InvoiceNo'].count().reset_index(name ='NumRecords')
print(country_sales)

country_sales_order = country_sales.sort_values(['NumRecords'],ascending=False)
print(country_sales_order)


Ireland_sales = df[df['Country'] =="EIRE"].reset_index()
Ireland_sales.head(5)

Ireland_sales['Description'] = Ireland_sales['Description'].str.strip()

# After the cleanup, we need to consolidate the items into 1 transaction per row with each product 1 hot encoded.
basket = (df[df['Country'] =="EIRE"]
          .groupby(['InvoiceNo', 'Description'])['Quantity']
          .sum().unstack().reset_index().fillna(0)
          .set_index('InvoiceNo'))
print(basket)

#list the columns. There are 2027 columns
print(basket.columns)

Index([' 4 PURPLE FLOCK DINNER CANDLES', ' 50'S CHRISTMAS GIFT BAG LARGE',
       ' DOLLY GIRL BEAKER', ' NINE DRAWER OFFICE TIDY',
       ' OVAL WALL MIRROR DIAMANTE ', ' RED SPOT GIFT BAG LARGE',
       ' SPACEBOY BABY GIFT SET', ' TRELLIS COAT RACK',
       '10 COLOUR SPACEBOY PEN', '12 COLOURED PARTY BALLOONS',
       ...
       'ZINC FOLKART SLEIGH BELLS', 'ZINC HEART FLOWER T-LIGHT HOLDER',
       'ZINC HERB GARDEN CONTAINER', 'ZINC METAL HEART DECORATION',
       'ZINC SWEETHEART WIRE LETTER RACK', 'ZINC T-LIGHT HOLDER STAR LARGE',
       'ZINC T-LIGHT HOLDER STARS SMALL', 'ZINC WILLIE WINKIE  CANDLE STICK',
       'ZINC WIRE KITCHEN ORGANISER', 'ZINC WIRE SWEETHEART LETTER TRAY'],
      dtype='object', name='Description', length=2027)