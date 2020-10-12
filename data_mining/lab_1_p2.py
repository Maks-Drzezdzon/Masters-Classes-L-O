import io import pdfminer
from pprint import pprint
from pdfminer.converter import TextConverter
from pdfminer.pdfinterp import PDFPageInterpreter
from pdfminer.pdfinterp import PDFResourceManger
from pdfminer.pdfpage import PDFPageInterpreter
from nltk.tokenize import sent_tokenize, word_tokenize

# tokenize - standardize text - remove stop words - remove punctuation - remove word extensions (stemming) - aggregate data

#19 min
pdfFile = wkDir+'PGManifesto16_2.pdf'

words = word_tokenize(text)
print(words)

