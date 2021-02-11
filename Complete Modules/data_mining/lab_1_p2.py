import io, pdfminer, nltk
from pprint import pprint
from pdfminer.converter import TextConverter
from pdfminer.pdfinterp import PDFPageInterpreter
from pdfminer.pdfinterp import PDFResourceManger
from pdfminer.pdfpage import PDFPageInterpreter
from nltk.tokenize import sent_tokenize, word_tokenize
from urllib.request import urlopen
from bs4 import BeautifulSoup

# tokenize - standardize text - remove stop words - remove punctuation - remove word extensions (stemming) - aggregate data

#19 min
pdfFile = wkDir+'PGManifesto16_2.pdf'

words = word_tokenize(text)
print(words)

url = "http://www.oralytics.com/"
html = urlopen(url).read()
print(html)


soup = BeautifulSoup(html)
print(soup)

# kill all script and style elements
for script in soup(["script", "style"]):
    script.extract()    # rip it out

print(soup)


text = soup.get_text()
print(text)

# break into lines and remove leading and trailing space on each
lines = (line.strip() for line in text.splitlines())
# break multi-headlines into a line each
chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
# drop blank lines
text = '\n'.join(chunk for chunk in chunks if chunk)

print(text)


#download and print the stop words for the English language
from nltk.corpus import stopwords
#nltk.download('stopwords')
stop_words = set(stopwords.words('english'))
print(stop_words)

#tokenise the data set
from nltk.tokenize import sent_tokenize, word_tokenize
words = word_tokenize(text)
print(words)

# removes punctuation and numbers
wordsFiltered = [word.lower() for word in words if word.isalpha()]
print(wordsFiltered)

# remove stop words from tokenised data set
filtered_words = [word for word in wordsFiltered if word not in stopwords.words('english')]
print(filtered_words)



from wordcloud import WordCloud
import matplotlib.pyplot as plt

wc = WordCloud(max_words=1000, margin=10, background_color='white',
               scale=3, relative_scaling = 0.5, width=500, height=400,
               random_state=1).generate(' '.join(filtered_words))

plt.figure(figsize=(20,10))
plt.imshow(wc)
plt.axis("off")
plt.show()
#wc.to_file("/wordcloud.png")




from collections import Counter

# count frequencies
cnt = Counter()
for word in filtered_words:
    cnt[word] += 1

print(cnt)

from wordcloud import WordCloud
import matplotlib.pyplot as plt

wc = WordCloud(max_words=1000, margin=10, background_color='white',
               scale=3, relative_scaling = 0.5, width=500, height=400,
               random_state=1).generate_from_frequencies(cnt)

plt.figure(figsize=(20,10))
plt.imshow(wc)
#plt.axis("off")
plt.show()