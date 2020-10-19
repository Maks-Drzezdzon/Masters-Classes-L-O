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
