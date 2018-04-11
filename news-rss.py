import feedparser
from newspaper import Article
from googletrans import Translator
import smtplib
from email.mime.text import MIMEText
import os

rss = 'http://ep00.epimg.net/rss/elpais/portada_america.xml'
feed = feedparser.parse(rss)
url = feed['entries'][0]['link']


article = Article(url)
article.download()
article.parse()
original_text = article.text
paragraph = original_text.split('\n')


translator = Translator()
eng_translation = []
for text in paragraph:
    eng_translation.append(translator.translate(text).text)
merged_paragraph = list(zip(paragraph, eng_translation))

message = ''
for org, tran in filter(None, merged_paragraph):
    message += org
    message += '\n\n'
    message += tran


to = 'iacutone@protonmail.com'
gmail_user = 'eric.iacutone@gmail.com'
# gmail_pwd = os.environ['GMAIL_PASSWORD']
smtpserver = smtplib.SMTP("smtp.gmail.com", 587)
smtpserver.ehlo()
smtpserver.starttls()
smtpserver.login(gmail_user, gmail_pwd)
header = 'To:' + to + '\n' + 'From: ' + gmail_user + '\n' + "Subject:Today's Article\n"
msg = header + MIMEText(message, _charset="UTF-8").as_string()
smtpserver.sendmail(gmail_user, to, msg)
smtpserver.close()
