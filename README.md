Here you will find instructions to manage the translation of "Open Education
Handbook" for Campinas's Education Freedom Day 2014.

Requirements
------------

- Make
- [Translate
  Toolkit](http://docs.translatehouse.org/projects/translate-toolkit/en/latest/installation.html)
- [Transifex
  Client](http://support.transifex.com/customer/portal/articles/995605-installation)

Update server
-------------

~~~
$ make push USERNAME=your_username PASSWORD=your_password
~~~

It will download the book from Booktype, unzip it, remove old resources in
Transifex's server and upload the new ones.

Build translation zip
---------------------

~~~
$ make reassemble
~~~

It will download the book from Booktype, unzip it, download the translation to
Transifex's server, update the zip file.
