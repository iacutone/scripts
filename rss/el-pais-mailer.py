#!/usr/bin/env python

from rss_feed import RssFeed
from parse_article import ParseArticle
from translate_article import TranslateArticle
from mailchimp_emails import MailchimpEmails
from mailer import Mailer

rss_feed = RssFeed.parse('http://ep00.epimg.net/rss/elpais/portada_america.xml')
article_text = ParseArticle.new(rss_feed)
translated_article = TranslateArticle(article_text)
emails = MailchimpEmails.get()

Mailer(emails, translated_article)
